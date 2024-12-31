resource "google_cloudbuild_trigger" "repo-trigger" {
  name            = var.name
  project         = var.project
  location        = var.location
  service_account = var.service_account
  filename        = var.filename

  repository_event_config {
    repository = var.repository_event_config.repository

    push {
      branch       = var.repository_event_config.branch
      invert_regex = var.repository_event_config.invert_regex
    }
  }
}