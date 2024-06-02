# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# terraform {
#   required_providers {
#     aws = {
#       version = "~> 2.13.0"
#     }
#     random = {
#       version = ">= 2.1.2"
#     }
#   }

#   required_version = "~> 0.12.29"
# }

provider "aws" {
  region = "us-west-2"
}

provider "random" {}

resource "random_pet" "name" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")

  tags = {
    Name = random_pet.name.id
  }
}

# terraform version
# terraform init — error due to old terraform version

terraform {
  required_providers {
    aws = {
      version = ">= 2.13.0"
    }
    random = {
      version = ">= 2.1.2"
    }
  }

  required_version = "~> 1.4.5"
}

# terraform init
# terraform apply

# grep -e '"version"' -e '"terraform_version"' terraform.tfstate
# Terraform will only update the state file version when a new version of Terraform requires a change to the state file's format
# Terraform will update the terraform_version whenever you apply a change to your configuration using a newer Terraform version.
# Once you use a newer version of Terraform's state file format on a given project, there is no supported way to revert to using an older state file version.

# 0.15.0 — fixed version
# >= 0.15 — any version 0.15 or later
# ~> 0.15.0 — any version 0.15.x
# >= 0.15, < 2.0.0 — 0.15 or later, but before 2.0.0

# terraform destroy
