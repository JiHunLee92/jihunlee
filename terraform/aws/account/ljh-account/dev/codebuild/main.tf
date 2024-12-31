################################################################################
# CodeBuild
################################################################################

module "test_codebuild" {
  source = "../../../../module/codebuild"

  codebuild_name = "${var.name}-${var.environment}-codebuild"
  # image = use standard default
  region              = var.region
  account_id          = var.account_id
  environment         = var.environment
  ecr_repository_name = data.terraform_remote_state.ecr.outputs.admin_ecr_name

  codebuild_role_arn = data.terraform_remote_state.iam.outputs.codebuild_role
  source_repo        = "https://github.com/test-ljh/devops"
  source_branch      = var.source_branch
}