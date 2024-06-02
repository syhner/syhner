provider "aws" {
  region = var.aws_region
}

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

  cidr = var.aws_vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.aws_private_subnet_cidrs
  public_subnets  = var.aws_public_subnet_cidrs

  enable_dns_support = var.enable_dns

  enable_nat_gateway = true
  enable_vpn_gateway = false
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "app" {
  source = "./modules/example-app-deployment"

  aws_instance_count = var.aws_instance_count

  aws_instance_type = var.aws_instance_type
  aws_ami_id        = data.aws_ami.amazon_linux.id
  aws_vpc_id        = module.vpc.vpc_id

  aws_public_subnet_ids  = module.vpc.public_subnets
  aws_private_subnet_ids = module.vpc.private_subnets
}

# Terraform configuration can be syntactically valid and deployable, but still not satisfy other constraints such as application-specific requirements. When you maintain a module, you can use custom conditions in your configuration to enforce these requirements.
# cp terraform.tfvars.example terraform.tfvars — This file sets values for three of the variables used by the example configuration. Terraform can deploy your infrastructure with these values, but they do not meet the hypothetical requirements of the example application, which needs an EC2 instance that supports EBS optimization, and a VPC that has DNS support enabled.

# terraform init
# terraform plan — will succeed because configuration can't detect 

# Terraform allows you to add preconditions and postconditions to the lifecycle of resource, data source, or output blocks. Terraform evaluates preconditions before the enclosing block, validating that your configuration is compliant before it applies it. Terraform evaluates post conditions after the enclosing block, letting you confirm that the results of applied changes are compliant before it applies the rest of your configuration.

# added data source and preconditions to modules/example-app-deployment/main.tf
# terraform plan — will fail because of the conditions
# update terraform.tfvars to meet the conditions (aws_instance_type = "t3.micro", aws_instance_count = 4)
# terraform plan — success

# added data source with postcondition to modules/example-app-deployment/main.tf
# The postcondition refers to the data source using the self value. Terraform will not create the VPC until you apply the example configuration, so it cannot validate this condition until after it has begun provisioning your infrastructure. When you run terraform apply, Terraform will start applying the configuration, and will create the VPC before it reads its attributes from the data source. After it does so, it will evaluate the postcondition and report an error if it fails.
# terraform apply — will fail only after confirming with 'yes'
# update terraform.tfvars to meet the conditions (enable_dns = true)
# terraform apply — success

# terraform destroy
