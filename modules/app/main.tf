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

resource "aws_instance" "appservers" {
  count = var.num_instances
  
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = var.appserver_subnet_id

security_groups = [ var.appserver_sg ]
  key_name = var.key_pair
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF

  tags = {
    Name = "AppServer-${count.index}"
  }
}

resource "aws_eip" "pubtest" {
  count = var.num_instances
  instance = element(split(",", join(",", aws_instance.appservers.*.id)), count.index)
  vpc      = true
}

resource "aws_eip_association" "pubtest" {
  count = var.num_instances
  instance_id   = element(split(",", join(",", aws_instance.appservers.*.id)), count.index)
  allocation_id = element(split(",", join(",", aws_eip.pubtest.*.id)), count.index)
}

### LOAD BALANCER ###

# AppServer ELB
resource "aws_lb" "appserver_lb" {
  name               = "appserver-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ var.public_subnet_sg ]  
  subnets            = [ var.primary_public_subnet_id, var.secondary_public_subnet_id ] 

  enable_deletion_protection = false

}

# AppServer TG
resource "aws_lb_target_group" "appserver_lb_tg_80" {
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "instance"

}
# AppServer TG Attachment
resource "aws_lb_target_group_attachment" "appserver_lb_tga_443" {
    count = var.num_instances
    target_group_arn = aws_lb_target_group.appserver_lb_tg_80.arn
    target_id        = element(split(",", join(",", aws_instance.appservers.*.id)), count.index)
}

# AppServer ELB Listener and Rules
resource "aws_lb_listener" "appserver_lb_listener_80" {
  load_balancer_arn = aws_lb.appserver_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = 443
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "appserver_lb_listener_443" {
  load_balancer_arn = aws_lb.appserver_lb.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy		=	"ELBSecurityPolicy-2016-08"
  certificate_arn		=	var.loadbalancer_cert
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.appserver_lb_tg_80.arn
  }
}
