terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.65.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.21.0"
    }
  }
}
