# terraform {
#   required_providers {
#     aws = {
#       # hostname=registry.terraform.io/namespace/provider
#       source = "hashicorp/aws"
#       # Optional version constraint (otherwise latest version is used)
#       version = "~> 4.16"
#     }
#   }

#   required_version = ">= 1.2.0"
# }

provider "aws" {
  region = "us-west-2"
}

# resource <type> <name>
# ec2 instance id <type>.<name> = aws_instance.app_server
# Terraform will manage resource with prefix of type = aws

# resource "aws_instance" "app_server" {
#   ami           = "ami-830c94e3"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }

# terraform init — install providers
# terraform fmt — prettify
# terraform validate — validate syntactically correct

# terraform apply — create infrastructure (and write resource metadata from aws to state file)
# (+) indicates resource will be created

# terraform show — inspect current state
# terraform state list

# Changing the AMI for an instance requires recreating it
# resource "aws_instance" "app_server" {
#   ami           = "ami-08d70e59c07c61a3a"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }

# terraform apply
# -/+ resource "aws_instance" "app_server" — destroy and recreate (-/+), rather than updating in place (~)

# terraform destroy — destroy infrastructure
# (-) indicates resource will be destroyed

# Add variables.tf

resource "aws_instance" "app_server" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

# terraform validate — also validates variables
# terraform apply
# terraform apply -var "instance_name=YetAnotherName"

# Add outputs.tf
# terraform output — show outputs

terraform {
  cloud {
    organization = "syhner"
    workspaces {
      name = "learn-tfc-aws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

# terraform init — re-initialize configuration and migrate your state file to Terraform Cloud
# rm terraform.tfstate && rm terraform.tfstate.backup — remove local state files since they are now in Terraform Cloud
# terraform apply — no changes (streamed from terraform cloud, cancelling will only cancel the log stream and not the apply)
# terraform destroy
