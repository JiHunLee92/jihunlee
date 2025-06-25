data "terraform_remote_state" "iam" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-iam"
    }
  }
}

data "terraform_remote_state" "ecr" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-ecr"
    }
  }
}