terraform {
  backend "remote" {
    organization = "nbt-devops"
    workspaces {
      name = "test-dev-gke-google-modules-v1"
    }
  }

  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.devops_project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${module.devops_gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.devops_gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.devops_gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.devops_gke.ca_certificate)
  }
}