data "terraform_remote_state" "elasticbeanstalk" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-elasticbeanstalk"
    }
  }
}

data "aws_route53_zone" "test_com" {
  name         = "test.com."
  private_zone = false
}

# data "terraform_remote_state" "network" {
#   backend = "remote"

#   config = {
#     organization = "test-devops"
#     workspaces = {
#       name = "test-dev-network"
#     }
#   }
# }

# data "aws_route53_zone" "internal_co" {
#   name         = "internal.co."
#   private_zone = true
#   vpc_id       = data.terraform_remote_state.network.outputs.vpc_id
# }

