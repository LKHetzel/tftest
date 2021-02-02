# VPC
resource "aws_vpc" "systemvpc" {
  cidr_block = "10.0.0.0/16"

tags = {
    deployment_type = "dev"
    owner           = "logan"
    Name            = "SystemVPC"
    }

}

# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.systemvpc.id

  tags = {
    Name = "SystemIGW"
  }
}

# Subnets
# AppServer Subnet
resource "aws_subnet" "appserver_subnet" {
  vpc_id            = aws_vpc.systemvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.aws_primary_az
  tags = {
      Name = "appserver-subnet"
  }
}

# WorkerServer Subnet
resource "aws_subnet" "workerserver_subnet" {
  vpc_id            = aws_vpc.systemvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.aws_primary_az
    tags = {
      Name = "workerserver-subnet"
  }
}

# Primary Public Subnet for LB, etc
resource "aws_subnet" "primary_public_subnet" {
  vpc_id = aws_vpc.systemvpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.aws_primary_az
    tags = {
      Name = "public-subnet-1"
  }
}

resource "aws_subnet" "secondary_public_subnet" {
  vpc_id = aws_vpc.systemvpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.aws_secondary_az
      tags = {
      Name = "public-subnet-2"
  }
}

# Route Table

resource "aws_route_table" "SystemRTB" {
    vpc_id = aws_vpc.systemvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

# Security Groups and ACL
# AppServer SG
resource "aws_security_group" "appserver_sg" {
  vpc_id            = aws_vpc.systemvpc.id 
  name              = "Application Server Cluster Security Group"
  tags = {
      Name = "AppServer SG"
  }
  
  # Allow ingress on port 22 for SSH
  ingress {
      cidr_blocks   = ["0.0.0.0/0"]
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"
  }  

  # Allow ingress from LB on 80
  ingress {
      cidr_blocks   = ["0.0.0.0/0"]
      from_port     = 80
      to_port       = 80
      protocol      = "tcp"
  }
  # Egress
  egress {
      from_port     = 0
      to_port       = 0
      protocol      = -1
      cidr_blocks   = ["0.0.0.0/0"]
  }  
}

#AppServer ACL
resource "aws_network_acl" "appserver_acl" {
  vpc_id            = aws_vpc.systemvpc.id
  subnet_ids        = [ aws_subnet.appserver_subnet.id ]
  tags = {
      Name = "AppServer ACL"
  }
  
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.systemvpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

# WorkerServer SG
resource "aws_security_group" "workerserver_sg" {
  vpc_id            = aws_vpc.systemvpc.id 
  name              = "Worker Server Cluster Security Group"
  
  # Allow ingress on port 22 for SSH
  ingress {
      cidr_blocks   = ["0.0.0.0/0"]
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"
  }  

  # Egress
  egress {
      from_port     = 0
      to_port       = 0
      protocol      = -1
      cidr_blocks   = ["0.0.0.0/0"]
  }  
}

# WorkerServer ACL
resource "aws_network_acl" "workerserver_acl" {
  vpc_id            = aws_vpc.systemvpc.id
  subnet_ids        = [ aws_subnet.workerserver_subnet.id ]
  
  # Allow ingress tcp/22
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.systemvpc.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

# Public SG
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.systemvpc.id
  name = "Public Resources Security Group"
  ingress {
      cidr_blocks   = ["0.0.0.0/0"]
      from_port     = 443
      to_port       = 443
      protocol      = "tcp"
  }
    ingress {
      cidr_blocks   = ["0.0.0.0/0"]
      from_port     = 80
      to_port       = 80
      protocol      = "tcp"
  }
  # Egress
  egress {
      from_port     = 0
      to_port       = 0
      protocol      = -1
      cidr_blocks   = ["0.0.0.0/0"]
  } 
}

# Aurora SG
resource "aws_security_group" "aurora_sg" {
  name   = "aurora-security-group"
  vpc_id = aws_vpc.systemvpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}
