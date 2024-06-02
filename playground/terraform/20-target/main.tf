# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      hashicorp-learn = "resource-targeting"
    }
  }
}

resource "random_pet" "bucket_name" {
  length    = 5
  separator = "-"
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.3.0"

  bucket = random_pet.bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = module.s3_bucket.s3_bucket_id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = module.s3_bucket.s3_bucket_id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.bucket]
}

resource "random_pet" "object_names" {
  count = 4

  length    = 5
  separator = "_"
  prefix    = "learning"
}

resource "aws_s3_object" "objects" {
  count = 4

  acl          = "public-read"
  key          = "${random_pet.object_names[count.index].id}.txt"
  bucket       = module.s3_bucket.s3_bucket_id
  content      = "Bucket object #${count.index}"
  content_type = "text/plain"
}

# Occasionally you may want to apply only part of a plan, such as when Terraform's state has become out of sync with your resources due to a network failure, a problem with the upstream cloud platform, or a bug in Terraform or its providers. To support this, Terraform lets you target specific resources when you plan, apply, or destroy your infrastructure. Targeting individual resources can be useful for troubleshooting errors, but should not be part of your normal workflow.

# terraform init
# terraform apply
# change random_pet.bucket_name.length
# terraform plan — will cause recreations since resources are dependent on random_pet.bucket_name
# terraform plan -target="random_pet.bucket_name" — only 1 resource will be recreated since it is targeted
# terraform plan -target="module.s3_bucket"

# Resource targeting updates resources that the target depends on, but not resources that depend on it.

# terraform apply -target="random_pet.bucket_name" — apply the change to only the bucket name. bucket_name output changes, and no longer matches the bucket ARN. Open outputs.tf and note that the bucket name output value references the random pet resource, instead of the bucket itself.

# When using Terraform's normal workflow and applying changes to the entire working directory, the bucket name modification would apply to all downstream dependencies as well. Because you targeted the random pet resource, Terraform updated the output value for the bucket name but not the bucket itself. Targeting resources can introduce inconsistencies, so you should only use it in troubleshooting scenarios.
# updated ouput.bucket_name to use bucket name instead of pet name

# terraform apply — After using resource targeting to fix problems with a Terraform project, be sure to apply changes to the entire configuration to ensure consistency across all resources. (had to run twice due to ACL error)

# made a change to bucket objects content
# terraform apply -target="aws_s3_object.objects[2]" -target="aws_s3_object.objects[3]" — target specific bucket objects (notifies that the changes to your infrastructure may be incomplete)

# removed prefix from random pet
# terraform apply -target="aws_s3_object.objects[2]" — updates all five of the random_pet.object_name resources, not just the name of the object you targeted. Both random_pet.object_name and aws_s3_object.object use count to provision multiple resources, and each bucket object refers to the name of the same index. However, because the entire aws_s3_bucket_objects.objects resource depends on the entire random_pet.object_names resource, Terraform updated all the names.

# terraform destroy -target="aws_s3_object.objects" — target with destroy, refer to the entire collection of resources (of objects)
# terraform destroy — destroy rest of infrastructure
