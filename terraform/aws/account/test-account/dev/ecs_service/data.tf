data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-ecs-cluster"
    }
  }
}

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

data "terraform_remote_state" "iam" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-iam"
    }
  }
}

data "terraform_remote_state" "elb" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-elb"
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