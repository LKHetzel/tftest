data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "workerserver-nic" {
  count = var.num_instances
  subnet_id = var.workerserver_subnet_id
  tags = {
      Name = "WorkerServer-nic-${count.index}"
  }
}



resource "aws_instance" "workerservers" {
  count = var.num_instances
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  
  network_interface {
    network_interface_id = aws_network_interface.workerserver-nic[count.index].id
    device_index = 0
  }

  tags = {
    Name = "WorkerServer-${count.index}"
  }
}