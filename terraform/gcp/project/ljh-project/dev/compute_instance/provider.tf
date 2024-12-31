terraform {
  backend "remote" {
    organization = "test-devops"
    workspaces {
      name = "test-dev-compute-instance"
    }
  }

  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project_id
  zone    = var.zone
}