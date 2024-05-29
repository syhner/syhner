provider "aws" {
  region = var.region

  default_tags {
    tags = {
      hashicorp-learn = "move-config"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc_renamed" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway      = var.vpc_enable_nat_gateway
  map_public_ip_on_launch = true

  tags = var.vpc_tags
}

# module "security_group" {
#   source = "./modules/security_group"
#   vpc_id = module.vpc.vpc_id
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "example" {
#   ami                         = data.aws_ami.ubuntu.id
#   subnet_id                   = module.vpc.public_subnets[0]
#   instance_type               = "t2.micro"
#   vpc_security_group_ids      = [module.security_group.security_group_id]
#   associate_public_ip_address = true

#   user_data = <<-EOF
#               #!/bin/bash
#               apt-get update
#               apt-get install -y apache2
#               sed -i -e 's/80/8080/' /etc/apache2/ports.conf
#               echo "Hello World" > /var/www/html/index.html
#               systemctl restart apache2
#               EOF
#   tags = {
#     Name = "terraform-learn-move-ec2"
#   }
# }

# terraform init
# terraform apply
# moved aws_ami.ubuntu and aws_instance.example to modules/compute/main.tf
# created variables and outputs in modules/compute/
# replacing security_group module by AWS-security-group from Terraform Registry
module "web_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  vpc_id = module.vpc_renamed.vpc_id

  use_name_prefix = false

  name        = "terraform-learn-move-sg"
  description = "Security Group managed by Terraform"

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
# Use new compute module
module "ec2_instance" {
  source         = "./modules/compute"
  security_group = module.web_security_group.security_group_id
  public_subnets = module.vpc_renamed.public_subnets
}
# terraform init
# terraform plan — will destroy and recreate (causing downtime)

# With the moved configuration block, you can inform Terraform about all resource address changes in your configuration. Terraform also validates those changes to provide you with clearer operational output and you can safely review plans before applying.
moved {
  from = module.security_group.aws_security_group.sg_8080
  to   = module.web_security_group.aws_security_group.this[0]
}
moved {
  from = module.security_group.aws_security_group_rule.ingress_rule
  to   = module.web_security_group.aws_security_group_rule.ingress_with_cidr_blocks[0]
}
moved {
  from = module.security_group.aws_security_group_rule.egress_rule
  to   = module.web_security_group.aws_security_group_rule.egress_with_cidr_blocks[0]
}
moved {
  from = aws_instance.example
  to   = module.ec2_instance.aws_instance.example
}
# terraform apply — now the changes are updates in-place

# You can also use the moved configuration block to rename existing resources.
moved {
  from = module.vpc
  to   = module.vpc_renamed
}
# terraform init
# terraform apply

# We strongly recommend you retain all moved blocks in your configuration as a record of your changes. Removing a moved block plans to delete that existing resource instead of moving it.

# terraform destroy
