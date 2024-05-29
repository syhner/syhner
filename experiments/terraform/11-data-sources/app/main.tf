# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

resource "random_string" "lb_id" {
  length  = 3
  special = false
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "4.0.0"

  # Ensure load balancer name is unique
  name = "lb-${random_string.lb_id.result}-tutorial-example"

  internal = false

  security_groups = data.terraform_remote_state.vpc.outputs.lb_security_group_ids
  subnets         = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  number_of_instances = length(aws_instance.app)
  instances           = aws_instance.app.*.id

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
}

resource "aws_instance" "app" {
  count = var.instances_per_subnet * length(data.terraform_remote_state.vpc.outputs.private_subnet_ids)

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id              = data.terraform_remote_state.vpc.outputs.private_subnet_ids[count.index % length(data.terraform_remote_state.vpc.outputs.private_subnet_ids)]
  vpc_security_group_ids = data.terraform_remote_state.vpc.outputs.app_security_group_ids

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/index.html
    EOF
}

# terraform init
# can use the terraform_remote_state data source to use another Terraform workspace's output data

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "syhner"
    workspaces = {

      name = "learn-terraform-data-sources-vpc"
    }
  }
}

# must explicitly allow TF Cloud workspaces to access one another's state through UI
# give access to app workspace for remote state sharing from vpc workspace

# aws region from data source
# aws instance count from data source
# elb security groups and subnets from data source

# Terraform's remote state data source can only load "root-level" output values from the source workspace, it cannot directly access values from resources or modules in the source workspace. To retrieve those values, you must add a corresponding output to the source workspace.

# You can use values from data sources just like any other Terraform values, including by passing them to functions.

# use aws provider data sources
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# aws instance ami from data source
# aws instance subnet_id and vpc_security_group_ids from data source

# terraform apply
# curl $(terraform output -raw lb_url) — check that load balancer is working

# terraform destroy
# cd ../vpc && terraform destroy -var aws_region=us-west-1
