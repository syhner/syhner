# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.24.1"
    }
  }
  required_version = ">= 0.15.2"
}

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_instance" "web_app" {
  for_each               = local.security_groups # each key and value of the map will be assigned to each.key and each.value respectively
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [each.value]
  user_data              = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World" > /var/www/html/index.html
              systemctl restart apache2
              EOF
  tags = {
    Name = "${var.name}-learn-${each.key}"
  }
}

resource "aws_security_group" "sg_ping" {
  name = "Allow Ping"
}

resource "aws_security_group" "sg_8080" {
  name = "Allow 8080"

  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_localhost_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.sg_8080.id
}

resource "aws_security_group_rule" "allow_localhost_ping" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = aws_security_group.sg_ping.id
}

# Four types of errors, ordered by closest to user:
# 1. Language errors: The primary interface for Terraform is the HashiCorp Configuration Language (HCL), a declarative configuration language. The Terraform core application interprets the configuration language. When Terraform encounters a syntax error in your configuration, it prints out the line numbers and an explanation of the error.
# 2. State errors: The Terraform state file stores information on provisioned resources. It maps resources to your configuration and tracks all associated metadata. If state is out of sync, Terraform may destroy or change your existing resources. After you rule out configuration errors, review your state. Ensure your configuration is in sync by refreshing, importing, or replacing resources.
# 3. Core errors: The Terraform core application contains all the logic for operations. It interprets your configuration, manages your state file, constructs the resource dependency graph, and communicates with provider plugins. Errors produced at this level may be a bug. Later in this tutorial, you will learn best practices for opening a GitHub issue for the core development team.
# 4. Provider errors: The provider plugins handle authentication, API calls, and mapping resources to services. Later in this tutorial, you will learn best practices for opening a GitHub issue for the provider development team.

# terraform fmt — lint and prettify
# fix linting errors
# terraform fmt

# terraform init — download providers
# terraform validate — will show a cycle error
# fix cycle error (remove ingress on both security groups)

# Add security group rules and reference the security group id — so AWS will create the security groups, then the rules, and then attach the rules to the groups

resource "aws_security_group_rule" "allow_ping" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.sg_ping.id
  source_security_group_id = aws_security_group.sg_8080.id
}

resource "aws_security_group_rule" "allow_8080" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_8080.id
  source_security_group_id = aws_security_group.sg_ping.id
}

# terraform validate — fails since the 'each; attribute in the vpc_security_group_ids cannot return the IDs because of the for_each error above it. Terraform did not return any security group IDs, so the each object is invalid. The error is due to an invalid reference a the for_each attribute because of a splat expression (*) in its value.
# Terraform's for_each attribute allows you to create a set of similar resources based on the criteria you define.
# Terraform cannot parse aws_security_group.*.id in this attribute because the splat expression (*) only interpolates list types, while the for_each attribute is reserved for map types. A local value can return a map type.

# tags attribute change to give each instance a unique name.
/*
-  for_each               = aws_security_group.*.id
+  for_each               = local.security_groups

-  vpc_security_group_ids = [each.id]
+  vpc_security_group_ids = [each.value]

-   Name = "${var.name}-learn"
+   Name = "${var.name}-learn-${each.key}"
*/

#  This converts the list of security groups to a map.
locals {
  security_groups = {
    sg_ping = aws_security_group.sg_ping.id,
    sg_8080 = aws_security_group.sg_8080.id,
  }
}

# terraform validate — errors because of the corrected for_each value, outputs do not capture the multiple instances in the aws_instance.web_app resources
# The for expression captures all of the elements of aws_instance.web_app in a temporary variable called instance. Then, Terraform returns all of the specified values of the instance elements. In this example, instance.id, instance.public_ip, and instance.tags.Name return every matching key value for each instance you created.

/*
 output "instance_id" {
   description = "ID of the EC2 instance"
-   value       = aws_instance.web_app.id
+   value       = [for instance in aws_instance.web_app: instance.id]
 }

 output "instance_public_ip" {
   description = "Public IP address of the EC2 instance"
-   value       = aws_instance.web_app.public_ip
+   value       = [for instance in aws_instance.web_app: instance.public_ip]
 }

output "instance_name" {
   description = "Tags of the EC2 instance"
-  value        = aws_instance.web_app.tags
+  value        = [for instance in aws_instance.web_app: instance.tags.Name]
}
*/

# terraform validate — success
# terraform apply

# Bug reporting
# Once you eliminate the possibility of language misconfiguration, version mismatching, or state discrepancies, consider bringing your issue to the core Terraform team or Terraform provider community as a bug report.
# terraform version — check version
# export TF_LOG_CORE=TRACE — enable core logging
# export TF_LOG_PROVIDER=TRACE — enable provider logging
# export TF_LOG_PATH=logs.txt — write logs to a file
# unset TF_LOG_CORE — disable core logging
# Consider submitting issue as a form topic for community input before submitting issue
# Create GitHub issue on the repository for the provider or core depending on the final error message in logs.txt source

# terraform destroy
