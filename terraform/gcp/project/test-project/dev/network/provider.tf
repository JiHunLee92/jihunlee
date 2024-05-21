terraform {
  backend "remote" {
    organization = "test-devops"
    workspaces {
      name = "test-dev-network"
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
  region  = var.region
}