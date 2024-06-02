# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = [for instance in aws_instance.web_app : instance.id]
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = [for instance in aws_instance.web_app : instance.public_ip]
}

output "instance_name" {
  description = "Tags of the EC2 instance"
  value       = [for instance in aws_instance.web_app : instance.tags.Name]
}
