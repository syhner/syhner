# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
  public_subnets  = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)

  enable_nat_gateway = true
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = var.resource_tags
}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.17.0"

  name        = "web-sg-${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
  description = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.17.0"

  name        = "lb-sg-${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
  description = "Security group for load balancer with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}

resource "random_string" "lb_id" {
  length  = 3
  special = false
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "4.0.1"

  # Ensure load balancer name is unique
  name = "lb-${random_string.lb_id.result}-${var.resource_tags["project"]}-${var.resource_tags["environment"]}"

  internal = false

  security_groups = [module.lb_security_group.security_group_id]
  subnets         = module.vpc.public_subnets

  number_of_instances = length(module.ec2_instances.instance_ids)
  instances           = module.ec2_instances.instance_ids

  listener = [{
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }]

  health_check = {
    target              = "HTTP:80/index.html"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
  }

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}

module "ec2_instances" {
  source = "./modules/aws-instance"

  depends_on = [module.vpc]

  instance_count     = var.instance_count
  instance_type      = var.ec2_instance_type
  subnet_ids         = module.vpc.private_subnets[*]
  security_group_ids = [module.app_security_group.security_group_id]

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}

# terraform init (tfswitch to 1.2.x)
# terraform apply

# Variable declarations can appear anywhere in your configuration files. However, we recommend putting them into a separate file called variables.tf

# Variable blocks have three optional arguments.
# 1. Description: A short description to document the purpose of the variable.
# 2. Type: The type of data contained in the variable.
# 3. Default: The default value.

# Variable values must be literal values, and cannot use computed values

# (use vars: aws region, vpc cidr block var, instance count, enable vpn gateway)

# terraform apply — no changes since the values are the same

# When Terraform interprets values, either hard-coded or from variables, it will convert them into the correct type if possible.

# The variables you have used so far have all been single values. Terraform calls these types of variables simple. Terraform also supports collection variable types that contain more than one value. Terraform supports several collection variable types.
# 1. List: A sequence of values of the same type.
# 2. Map: A lookup table, matching keys to values, all of the same type.
# 3. Set: An unordered collection of unique values, all of the same type.

# terraform console — to test expressions in the context of your configuration (vars not hot reloaded)
# > var.private_subnet_cidr_blocks
# > var.private_subnet_cidr_blocks[1]
# slice(var.private_subnet_cidr_blocks, 0, 3) — slice(list, start, end (exclusive))
# exit

# > var.resource_tags["environment"]

# The lists and map used were collection types. Terraform also supports two structural types. Structural types have a fixed number of values that can be of different types.
# 1. Tuple: A fixed-length sequence of values of specified types.
# 2. Object: A lookup table, matching a fixed set of keys to values of specified types.

# terraform apply — assigning values to variables
# 1. no default — prompted for a value
# 2. terraform apply -var ec2_instance_type=t2.micro
# 3. all files loaded from cwd with the name terraform.tfvars or *.auto.tfvars (cannot contain configuration such as resource definitions)
# 4. -var-file flag to specify other files by name
# 5. using environment variables (TF_VAR_ prefix e.g. $ export TF_VAR_instance_count=2)

# Terraform configuration files can also contain JSON

# terraform apply -var-file terraform.tfvars.example

# If there are different values assigned for a variable through these methods, Terraform will use the last value it finds, in order of precedence.
# 1. Environment variables
# 2. The terraform.tfvars file, if present.
# 3. The terraform.tfvars.json file, if present.
# 4. Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
# 5. Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

# terraform apply -var-file terraform.tfvars.example -var='resource_tags={project="my-project",environment="development"}'
# this will fail the validation in variables.tf
# validation is important since e.g. AWS load balancers have naming restricitons

# terraform destroy -var-file terraform.tfvars.example
