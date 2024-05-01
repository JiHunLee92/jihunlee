################################################################################
# CodeBuild
# link: https://app.terraform.io/app/nbt-devops/workspaces/devops-can-dev-codebuild
################################################################################

module "test_codebuild" {
  source = "../../../../module/codebuild/"

  name = "${var.svc_test}-${var.environment}"
  image = var.codebuild_java_image
  region = var.region
  account_id = var.account_id
  environment = var.environment
  ecr_repository_name = data.terraform_remote_state.ecr.outputs.test_ecr_repository_name

  codebuild_role_arn = data.terraform_remote_state.iam.outputs.test_codebuild_role
  source_repo = "https://github.com/test"
  source_branch = var.source_branch
}

module "test_web_codebuild" {
  source = "../../../../module/codebuild/"

  name = "${var.svc_test}-${var.environment}-web"
  # image = use standard default
  region = var.region
  account_id = var.account_id
  environment = var.environment
  ecr_repository_name = data.terraform_remote_state.ecr.outputs.test_web_ecr_repository_name

  codebuild_role_arn = data.terraform_remote_state.iam.outputs.test_codebuild_role
  source_repo = "https://github.com/test"
  source_branch = var.source_branch
}