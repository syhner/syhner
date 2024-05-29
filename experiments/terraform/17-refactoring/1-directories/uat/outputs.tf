# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "uat_website_endpoint" {
  value = "http://${aws_s3_bucket_website_configuration.uat.website_endpoint}/index.html"
}
