data "terraform_remote_state" "elasticbeanstalk" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-elasticbeanstalk"
    }
  }
}

data "aws_route53_zone" "test" {
  name         = "test.com."
  private_zone = false
}

