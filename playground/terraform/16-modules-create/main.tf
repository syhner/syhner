# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Terraform configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Disabled to speed things up
# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "3.18.1"

#   name = var.vpc_name
#   cidr = var.vpc_cidr

#   azs             = var.vpc_azs
#   private_subnets = var.vpc_private_subnets
#   public_subnets  = var.vpc_public_subnets

#   enable_nat_gateway = var.vpc_enable_nat_gateway

#   tags = var.vpc_tags
# }

module "website_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name = "j0pln-p08h7-9jbuq-mhbzk" # AWS S3 Bucket names must be globally unique and lowercase alphanumeric (with hypens)

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Terraform treats any local directory referenced in the source argument of a module block as a module.
# A typical file structure for a new module is:
# ├── LICENSE
# ├── README.md
# ├── main.tf
# ├── variables.tf
# ├── outputs.tf
# None of these files are required, or have any special meaning to Terraform when it uses your module. You can create a module with a single .tf file, or use any other file structure you like.
# variables.tf will contain the variable definitions for your module. When your module is used by others, the variables will be configured as arguments in the module block. Since all Terraform values must be defined, any variables that are not given a default value will become required arguments. Variables with default values can also be provided as module arguments, overriding the default value.

# terraform init
# mkdir -p modules/aws-s3-static-website-bucket

# Notice that there is no provider block in modules/aws-s3-static-website-bucket/main.tf configuration. When Terraform processes a module block, it will inherit the provider from the enclosing configuration. Because of this, we recommend that you do not include provider blocks in modules.
# Module outputs are read-only attributes

# Whenever you add a new module to a configuration, Terraform must install the module before it can be used. Both the terraform get and terraform init commands will install and update modules. The terraform init command will also initialize backends and install plugins.

# terraform get
# terraform apply — create s3 bucket (empty for now)
# upload contents of modules/aws-s3-static-website-bucket/www to s3 bucket
# aws s3 cp modules/aws-s3-static-website-bucket/www/ s3://$(terraform output -raw website_bucket_name)/ --recursive
# visit https://<YOUR BUCKET NAME>.s3-us-west-2.amazonaws.com/index.html to see static file

# remove the files which are not tracked by terraform
# aws s3 rm s3://$(terraform output -raw website_bucket_name)/ --recursive
# terraform destroy

/*

When building a module, consider three areas:

Encapsulation: Group infrastructure that is always deployed together.
Including more infrastructure in a module makes it easier for an end user to deploy that infrastructure but makes the module's purpose and requirements harder to understand.

Privileges: Restrict modules to privilege boundaries.
If infrastructure in the module is the responsibility of more than one group, using that module could accidentally violate segregation of duties. Only group resources within privilege boundaries to increase infrastructure segregation and secure your infrastructure.

Volatility: Separate long-lived infrastructure from short-lived.
For example, database infrastructure is relatively static while teams could deploy application servers multiple times a day. Managing database infrastructure in the same module as application servers exposes infrastructure that stores state to unnecessary churn and risk.



*/
