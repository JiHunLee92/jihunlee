resource "google_cloudbuild_trigger" "repo_trigger" {
  name            = var.name
  project         = var.project
  location        = var.location
  service_account = var.service_account
  filename        = var.filename
  substitutions   = var.substitutions

  repository_event_config {
    repository = var.repository_event_config.repository

    dynamic "push" {
      for_each = var.repository_event_config.branch_regex != null ? [true] : []
      content {
        branch       = var.repository_event_config.branch_regex
        invert_regex = var.repository_event_config.invert_regex
      }
    }

    dynamic "push" {
      for_each = var.repository_event_config.tag_regex != null ? [true] : []
      content {
        tag          = var.repository_event_config.tag_regex
        invert_regex = var.repository_event_config.invert_regex
      }
    }
  }
}