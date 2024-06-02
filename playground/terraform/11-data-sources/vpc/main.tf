# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region
}

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "3.14.0"

#   cidr = var.vpc_cidr_block

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
#   private_subnets = slice(var.private_subnet_cidr_blocks, 0, 2)
#   public_subnets  = slice(var.public_subnet_cidr_blocks, 0, 2)

#   enable_nat_gateway = true
#   enable_vpn_gateway = false

#   map_public_ip_on_launch = false
# }

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.9.0"

  name        = "web-server-sg"
  description = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.9.0"

  name        = "lb-sg-project-alpha-dev"
  description = "Security group for load balancer with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

# export TF_CLOUD_ORGANIZATION=syhner (or remove cloud block in terraform block if not using Terraform Cloud)
# terraform init

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(var.private_subnet_cidr_blocks, 0, 2)
  public_subnets  = slice(var.public_subnet_cidr_blocks, 0, 2)

  enable_nat_gateway = true
  enable_vpn_gateway = false

  map_public_ip_on_launch = false
}

# For output to use

data "aws_region" "current" {}

# terraform apply -var aws_region=us-west-1

# cd ../app (instructions follow there)
