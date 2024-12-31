data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-network"
    }
  }
}

data "terraform_remote_state" "sg" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-sg"
    }
  }
}

data "aws_acm_certificate" "test-com" {
  domain    = "*.test.com"
  key_types = ["RSA_2048"]
}

data "terraform_remote_state" "ec2" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-ec2"
    }
  }
}