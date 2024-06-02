# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.24.1"
    }
  }
  required_version = ">= 0.15"
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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/key.pub")
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.deployer.key_name
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_web.id
  ]
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World" > /var/www/html/index.html
              systemctl restart apache2
              EOF
  tags = {
    Name          = "terraform-learn-state-ec2"
    drift_example = "v1"
  }
}

resource "aws_security_group" "sg_ssh" {
  name = "sg_ssh"
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ssh-keygen -t rsa -C "<email>" -f ./key
# echo "region = \"$(aws configure get region)\"" > terraform.tfvars
# terraform init
# terraform apply
# terraform state list

# Introduce drift example:

# export SG_ID=$(aws ec2 create-security-group --group-name "sg_web" --description "allow 8080" --output text)
# echo $SG_ID
# aws ec2 authorize-security-group-ingress --group-name "sg_web" --protocol tcp --port 8080 --cidr 0.0.0.0/0 — create a new rule for the security group to provide TCP access to the instance on port 8080
# aws ec2 modify-instance-attribute --instance-id $(terraform output -raw instance_id) --groups $SG_ID — associate the security group created manually with the EC2 instance provisioned by Terraform (replaced your instance's SSH security group with a new security group that is not tracked in the Terraform state file)
# By default, Terraform compares your state file to real infrastructure whenever you invoke terraform plan or terraform apply. The refresh updates your state file in-memory to reflect the actual configuration of your infrastructure. This ensures that Terraform determines the correct changes to make to your resources.
# terraform plan -refresh-only — inspect what the changes to your state file would be due to infrastructure change (unlike with terraform refresh which would overwrite the state file)
# terraform apply -refresh-only — does not attempt to modify your infrastructure to match your Terraform configuration -- it only gives you the option to review and track the drift in your state file.
# If you ran terraform plan or terraform apply without the -refresh-only flag now, Terraform would attempt to revert your manual changes

# add security group to terraform config, and modify aws_instance vpc_security_group_ids to include the new security group

resource "aws_security_group" "sg_web" {
  name        = "sg_web"
  description = "allow 8080"
}

resource "aws_security_group_rule" "sg_web" {
  type              = "ingress"
  to_port           = "8080"
  from_port         = "8080"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_web.id
}

# terraform import aws_security_group.sg_web $SG_ID — associate resource definition with the security group created by CLI
# terraform import aws_security_group_rule.sg_web "$SG_ID"_ingress_tcp_8080_8080_0.0.0.0/0
# terraform state list — now includes the imported resource, however the instance still only allows port 8080 access because the modify-instance-attribute AWS CLI command detached the SSH security group.

# terraform apply — this updates the EC2 instance's security group to include both the security groups allowing SSH and 8080
# ssh ubuntu@$(terraform output -raw public_ip) -i key — confirm instance allows SSH
# curl $(terraform output -raw public_ip):8080 — confirm instance allows port 8080 access

# terraform destroy
