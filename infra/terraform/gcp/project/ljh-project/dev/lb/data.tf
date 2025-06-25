data "terraform_remote_state" "health_checks" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-health-check"
    }
  }
}

data "terraform_remote_state" "umigs" {
  backend = "remote"

  config = {
    organization = "test-devops"
    workspaces = {
      name = "test-dev-umig"
    }
  }
}

resource "google_compute_security_policy" "sec_from_office" {
  name = "test-dev-sec-from-office"

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable = false
    }
  }

  lifecycle { ignore_changes = [adaptive_protection_config] }
}