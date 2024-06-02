# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      hashicorp-learn = "refresh"
    }
  }
}

data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "Learn Refresh"
  }
}

# Review Terraform's implicit refresh behavior and the advantages of the -refresh-only flag over the deprecated terraform refresh subcommand.

# terraform init
# terraform apply

# A common error scenario that can prompt Terraform to refresh the contents of your state file is mistakenly modifying your credentials or provider configuration. Simulate this situation by updating your AWS provider's region. You will then review the proposed changes to your state file from a Terraform refresh.
# echo "region = \"$(aws configure get region)\"" > terraform.tfvars
# terraform plan -refresh-only — Terraform tries to locate the EC2 instance with the instance ID tracked in your state file but fails to locate it since it's in a different region. Terraform assumes that you destroyed the instance and wants to remove it from your state file. Refreshing your state file would drop your resources, so do not run the apply operation.
# A refresh-only apply operation also updates outputs, if necessary. If you have any other workspaces that use the terraform_remote_state data source to access the outputs of the current workspace, the -refresh-only mode allows you to anticipate the downstream effects.

# terraform refresh is not available in Terraform Cloud (since -refresh-only is preferred)

# rm terraform.tfvars — remove the region change
# terraform destroy
