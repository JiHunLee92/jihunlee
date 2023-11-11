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

data "aws_acm_certificate" "test-network" {
  domain    = "*.test.network"
  key_types = ["RSA_2048"]
}