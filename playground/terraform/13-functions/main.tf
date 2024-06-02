# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      hashicorp-learn = "learn-terraform-functions"
    }
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "sg_8080" {
  name   = "sg_8080"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  # lookup(map, key, default)
  ami                         = lookup(var.aws_amis, var.aws_region)
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_22.id, aws_security_group.sg_8080.id]
  associate_public_ip_address = true
  # AWS lets you configure EC2 instances to run a user-provided script -- called a user-data script -- at boot time
  user_data = templatefile("user_data.tftpl", { department = var.user_department, name = var.user_name })
  # Enables public SSH trafic for tutorial purposes
  key_name = aws_key_pair.ssh_key.key_name
}

# templatefile reads the file at the given path and renders its content as a template using a supplied set of template variables.
# Terraform will interpolate user_data.tftpl {department} and ${name} references using the templatefile function.
# variables.tf includes definitions for the user_name and user_department input variables, which the configuration uses to set the values for the corresponding template file keys.

# terraform init
# terraform apply
# terraform destroy

# The lookup function retrieves the value of a single element from a map, given its key.
# added aws_amis to variables.tf
# terraform plan -var "aws_region=us-east-2"

# generate new ssh key in cwd
# ssh-keygen -C "<email>" -f ssh_key

resource "aws_security_group" "sg_22" {
  name   = "sg_22"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("ssh_key.pub")
}

# terraform apply
# ssh ubuntu@$(terraform output -raw web_public_ip) -i ssh_key

# terraform destroy
