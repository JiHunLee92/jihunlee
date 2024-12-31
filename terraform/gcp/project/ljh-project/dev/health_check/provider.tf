terraform {
  backend "remote" {
    organization = "test-devops"
    workspaces {
      name = "test-dev-health-check"
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
}