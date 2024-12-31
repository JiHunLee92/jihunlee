data "terraform_remote_state" "compute_instance" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-compute-instance"
    }
  }
}