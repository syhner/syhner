variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "name" { default = "dynamic-aws-creds-vault-admin" }

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "vault" {
}

# configures AWS Secrets Engine to generate a dynamic token that lasts for 2 minutes.
resource "vault_aws_secret_backend" "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  path       = "${var.name}-path"

  default_lease_ttl_seconds = "120"
  max_lease_ttl_seconds     = "240"
}

# Configures a role for the AWS Secrets Engine named dynamic-aws-creds-vault-admin-role with an IAM policy that allows it iam:* and ec2:* permissions. This role will be used by the Terraform Operator workspace to dynamically generate AWS credentials scoped to this IAM policy.
resource "vault_aws_secret_backend_role" "admin" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "${var.name}-role"
  credential_type = "iam_user"

  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

output "backend" {
  value = vault_aws_secret_backend.aws.path
}

output "role" {
  value = vault_aws_secret_backend_role.admin.name
}
