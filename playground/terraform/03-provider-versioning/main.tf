# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = "us-west-2"
}

resource "random_pet" "petname" {
  length    = 5
  separator = "-"
}

# resource "aws_s3_bucket" "sample" {
#   bucket = random_pet.petname.id

#   acl    = "public-read"
#   region = "us-west-2"

#   tags = {
#     public_bucket = true
#   }
# }

# terraform init -upgrade — upgrade all providers to the latest version consistent within the version constraints specified in your configuration.
# terraform apply — doesn't work because acl and region are deprecated for the new aws provider version

resource "aws_s3_bucket" "sample" {
  bucket = random_pet.petname.id

  tags = {
    public_bucket = true
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.sample.id
  acl    = "public-read"
}

# terraform apply
# If the plan or apply steps fail, do not commit the lock file to version control
# terraform destroy
