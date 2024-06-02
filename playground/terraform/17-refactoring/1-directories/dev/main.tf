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

resource "aws_s3_bucket" "dev" {
  bucket = "${var.dev_prefix}-${random_pet.petname.id}"

  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "dev" {
  bucket = aws_s3_bucket.dev.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_acl" "dev" {
  bucket = aws_s3_bucket.dev.id

  acl        = "public-read"
  depends_on = [aws_s3_bucket_public_access_block.dev]
}

resource "aws_s3_bucket_policy" "dev" {
  bucket = aws_s3_bucket.dev.id

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
          aws_s3_bucket.dev.arn,
          "${aws_s3_bucket.dev.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "dev" {
  bucket = aws_s3_bucket.dev.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "dev" {
  bucket = aws_s3_bucket.dev.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "dev" {
  key          = "index.html"
  bucket       = aws_s3_bucket.dev.id
  content      = file("${path.module}/../assets/index.html")
  content_type = "text/html"

  depends_on = [aws_s3_bucket_acl.dev]
}
