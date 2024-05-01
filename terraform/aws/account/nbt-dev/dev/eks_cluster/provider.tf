terraform {
  backend "remote" {
    organization = "test-devops"
    workspaces {
      name = "test-dev-eks"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}