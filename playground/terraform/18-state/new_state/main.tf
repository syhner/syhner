terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.46.0"
    }
  }
  required_version = ">= 1.1.5"
}

variable "region" {
  description = "The AWS region your resources will be deployed"
}

provider "aws" {
  region = var.region
}

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

data "terraform_remote_state" "root" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

resource "aws_instance" "example_new" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.terraform_remote_state.root.outputs.security_group]
  user_data              = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World" > /var/www/html/index.html
              systemctl restart apache2
              EOF
  tags = {
    Name = "terraform-learn-state-ec2"
  }
}


output "public_ip" {
  value       = aws_instance.example_new.public_ip
  description = "The public IP of the web server"
}

output "security_group" {
  value = data.terraform_remote_state.root.outputs.security_group
}
