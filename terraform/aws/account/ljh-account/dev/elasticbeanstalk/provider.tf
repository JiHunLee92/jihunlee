terraform {
  backend "remote" {
    organization = "test-devops"
    workspaces {
      name = "test-dev-elasticbeanstalk"
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