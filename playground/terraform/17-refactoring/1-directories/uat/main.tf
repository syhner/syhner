terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_pet" "petname" {
  length    = 3
  separator = "-"
}

resource "aws_s3_bucket" "uat" {
  bucket = "${var.uat_prefix}-${random_pet.petname.id}"

  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "uat" {
  bucket = aws_s3_bucket.uat.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_acl" "uat" {
  bucket = aws_s3_bucket.uat.id

  acl        = "public-read"
  depends_on = [aws_s3_bucket_public_access_block.uat]
}

resource "aws_s3_bucket_policy" "uat" {
  bucket = aws_s3_bucket.uat.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutBucketAcl"
        ]
        Resource = [
          aws_s3_bucket.uat.arn,
          "${aws_s3_bucket.uat.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "uat" {
  bucket = aws_s3_bucket.uat.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "uat" {
  bucket = aws_s3_bucket.uat.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "uat" {
  key          = "index.html"
  bucket       = aws_s3_bucket.uat.id
  content      = file("${path.module}/../assets/index.html")
  content_type = "text/html"

  depends_on = [aws_s3_bucket_acl.uat]
}
