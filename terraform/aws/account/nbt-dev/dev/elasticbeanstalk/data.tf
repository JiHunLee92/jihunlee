data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-network"
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

data "terraform_remote_state" "ecr" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-ecr"
    }
  }
}

data "terraform_remote_state" "security_group" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-security-group"
    }
  }
}

data "aws_iam_role" "elasticbeanstalk_service_role" {
  name = "aws-elasticbeanstalk-service-role"
}

# data "aws_iam_instance_profile" "elasticbeanstalk_ec2_role" {
#   name = "aws-elasticbeanstalk-ec2-role"
# }

data "aws_iam_instance_profile" "elasticbeanstalk_ecs_role" {
  name = "test-dev-ec2-instance-profile"
}
