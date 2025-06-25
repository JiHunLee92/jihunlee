terraform {
  backend "remote" {
    organization = "test-devops"
    workspaces {
      name = "test-dev-route53"
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

