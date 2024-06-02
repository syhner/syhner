terraform {

  # cloud {
  #   organization = "syhner"

  #   workspaces {
  #     name = "learn-terraform-cloud"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.43.0"
    }
  }

  required_version = ">= 0.14.0"
}
