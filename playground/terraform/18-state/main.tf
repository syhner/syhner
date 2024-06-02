terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.24.1"
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

resource "aws_instance" "example" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_8080.id]
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

resource "aws_security_group" "sg_8080" {
  name = "terraform-learn-state-sg-8080"
  ingress {
    from_port   = "8080"
    to_port     = "8080"
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

output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the web server"
}

output "security_group" {
  value = aws_security_group.sg_8080.id
}

# aws configure get region
# cp terraform.tfvars.example terraform.tfvars (and set region to the same as above)
# terraform init
# terraform apply

# You should not manually change information in your state file in a real-world situation to avoid unnecessary drift between your Terraform configuration, state, and infrastructure. Any change in state could result in your infrastructure being destroyed and recreated at your next terraform apply

# state is stored in terraform.tfstate

# The resources section of the state file contains the schema for any resources you create in Terraform. The first key in this schema is the mode.
# mode — type of resource Terraform creates, either a resource (managed) or a data source (data)
# type — resource type, in this case the aws_ami type is a resource available in the aws provider.
# instances — list of attributes of the resource
# Terraform also marks dependencies between resources in state with the built-in dependency tree logic. Because your state file has a record of your dependencies, enforced by you with a depends_on attribute or by Terraform automatically, any changes to the dependencies will force a change to the dependent resource.

# terraform show — human readable output of the state file
# terraform state list — ist of resource names and local identifiers in state file (data.aws_ami.ubuntu, aws_instance.example, aws_security_group.sg_8080)

# replace resource without having to destroy and recreate everything, or modify the state file manually
# terraform plan -replace="aws_instance.example"
# terraform apply -replace="aws_instance.example"

# The terraform state mv command moves resources from one state file to another. You can also rename resources with mv. The move command will update the resource in state, but not in your configuration file. Moving resources is useful when you want to combine modules or resources from other states, but do not want to destroy and recreate the infrastructure.

# cd new_state
# cp ../terraform.tfvars .
# terraform init
# terraform apply

# Move the new EC2 instance resource you just created, aws_instance.example_new, to the old configuration's file in the directory above your current location, as specified with the -state-out flag. Set the destination name to the same name, since in this case there is no resource with the same name in the target state file.
# terraform state mv -state-out=../terraform.tfstate aws_instance.example_new aws_instance.example_new

# cd ..
# terraform state list — (data.aws_ami.ubuntu, aws_instance.example, aws_instance.example_new, aws_security_group.sg_8080)
# terraform plan — Because the new EC2 instance is present in state but not in the configuration, Terraform plans to destroy the moved instance, and remove the resource from the state file.

resource "aws_instance" "example_new" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_8080.id]
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

# terraform apply — No changes. Your infrastructure matches the configuration. Your configuration already matches the changes detected above. If you'd like to update the Terraform state to match, create and apply a refresh-only plan: terraform apply -refresh-only

# cd new_state && terraform destroy && cd .. — 0 destroyed since state was moved

# terraform state rm aws_security_group.sg_8080 — remove resource from state file (does not remove resource from configuration or destroy it, just 'loses track' of it) (does not remove the output value with its ID)
# terraform import aws_security_group.sg_8080 $(terraform output -raw security_group) — bring security group back into state file.

# aws ec2 terminate-instances --instance-ids $(terraform output -raw instance_id) — destroy the EC2 instance outside of Terraform
# terraform refresh — update the state file when physical resources change outside of the Terraform workflow.
# terraform state list — aws_instance.example should be gone, so the state file now reflects reality
# If the aws_instance.example (and instance_id output, public_ip output) is removed then an apply would not create / destroy any infrastructure

# terraform destroy
# terraform show — no output (state file resources list will be empty)
