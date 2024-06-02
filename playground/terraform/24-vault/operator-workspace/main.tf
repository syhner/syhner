variable "name" { default = "dynamic-aws-creds-operator" }
variable "region" { default = "us-east-1" }
variable "path" { default = "../vault-admin-workspace/terraform.tfstate" }
variable "ttl" { default = "1" }

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Retrieves the Terraform state file generated from your Vault Admin workspace
data "terraform_remote_state" "admin" {
  backend = "local"

  config = {
    path = var.path
  }
}

# Retrieves the dynamic, short-lived AWS credentials from your Vault instance. Notice that this uses the Vault Admin workspace's output variables: backend and role
data "vault_aws_access_credentials" "creds" {
  backend = data.terraform_remote_state.admin.outputs.backend
  role    = data.terraform_remote_state.admin.outputs.role
}

# Initialized with the short-lived credentials retrieved by vault_aws_access_credentials.creds
provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

# Retrieve the most recent ubuntu image
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

# Create AWS EC2 Instance
resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"

  tags = {
    Name  = var.name
    TTL   = var.ttl
    owner = "${var.name}-guide"
  }
}
