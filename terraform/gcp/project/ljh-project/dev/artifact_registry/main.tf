module "test_app" {
  source = "../../../../module/artifact_registry/"

  location      = var.location
  repository_id = var.test_app_repository_id
}