################################################################################
# CodeBuild
################################################################################

module "testcodebuild" {
  source = "../../../../module/codebuild/"

  codebuild_name      = "${var.name}-${var.environment}-codebuild"
  image               = var.codebuild_java_image
  region              = var.region
  account_id          = var.account_id
  environment         = var.environment
  ecr_repository_name = data.terraform_remote_state.ecr.outputs.test_ecr_repository_name

  codebuild_role_arn = data.terraform_remote_state.iam.outputs.test_codebuild_role
  source_repo        = "https://github.com/test"
  source_branch      = var.source_branch
}

module "test_admin_codebuild" {
  source = "../../../../module/codebuild/"

  codebuild_name = "${var.name}-${var.environment}-admin-codebuild"
  # image = use standard default
  region              = var.region
  account_id          = var.account_id
  environment         = var.environment
  ecr_repository_name = data.terraform_remote_state.ecr.outputs.test_admin_ecr_repository_name

  codebuild_role_arn = data.terraform_remote_state.iam.outputs.test_codebuild_role
  source_repo        = "https://github.com/test"
  source_branch      = var.source_branch
}