data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-network"
    }
  }
}

data "local_file" "public_key_openssh" {
  filename = "data-dev.pub"
}