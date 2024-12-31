module "test" {
  source = "../../../../module/cloudbuild/"

  name            = var.test_name
  project         = var.project_id
  location        = var.test_location
  service_account = data.google_service_account.cloudbuild-test.id
  filename        = var.test_filename
  repository_event_config = {
    repository   = var.test_repository_id
    branch       = var.test_repository_branch
    invert_regex = var.test_invert_regex
  }
}