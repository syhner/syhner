# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      hashicorp-learn = "module-use"
    }
  }
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.14.0
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
  count   = 2

  name = "my-ec2-cluster"

  ami                    = "ami-0c5204531f799e0c6"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Any directory with terraform files is a module, subdirectories are child modules and the root directory is the root module

# Module best practices:
# 1. Name your provider terraform-<PROVIDER>-<NAME>. You must follow this convention in order to publish to the Terraform Cloud or Terraform Enterprise module registries.
# 2. Start writing your configuration with modules in mind. 
# 3. Use local modules to organize and encapsulate your code.
# 4. Use the public Terraform Registry to find useful modules.
# 5. Publish and share modules with your team. Module users can reference published child modules in a root module, or deploy no-code ready modules through the Terraform Cloud UI.

# source argument is required when you use a Terraform module
# version argument is not required, but is highly recommend to include when using a Terraform module. Without the version argument, Terraform will load the latest version of the module

# see inputs tab in browser for the module to see what variables are required and optional  
# also see outputs tab to see what outputs are available from the module
# outputs are references by module.<MODULE_NAME>.<OUTPUT_NAME> (see outputs.tf)

# terraform init (or terraform get first to install modules separately) — modules are installed to .terraform/modules (local modules are symlinked so no need to rerun get, whereas remote modules are cloned)
# terraform apply
# terraform destroy

/*
Nested modules can be located externally and are referred to as "child modules", or embedded inside the current workspace and are referred to as "submodules".
*/
