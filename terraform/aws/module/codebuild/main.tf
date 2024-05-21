###############################################################################
# CodeBuild
###############################################################################

resource "aws_codebuild_project" "this" {
  name          = var.codebuild_name
  description   = "Build and push Docker images to ECR for ${var.codebuild_name}"
  build_timeout = "60"

  # service_role  = data.aws_iam_role.codebuild_role.arn
  service_role = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repository_name
    }
  }

  source {
    type            = "GITHUB"
    location        = var.source_repo
    git_clone_depth = 1
    buildspec       = "buildspec.yml"

    git_submodules_config {
      fetch_submodules = false
    }
  }
  source_version = var.source_branch

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )
}

################################################################################
# CodeBuild Webhook
################################################################################

resource "aws_codebuild_webhook" "this" {
  project_name = aws_codebuild_project.this.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
  }
  # filter_group {
  #   filter {
  #     type    = "EVENT"
  #     pattern = "PULL_REQUEST_MERGED"
  #   }

  #   filter {
  #     type    = "HEAD_REF"
  #     pattern = var.source_branch
  #   }
  # }
}