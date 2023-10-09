###############################################################################
# Repository
###############################################################################

resource "aws_ecr_repository" "this" {

  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )
}

################################################################################
# Lifecycle Policy
################################################################################

resource "aws_ecr_lifecycle_policy" "this" {

  repository = aws_ecr_repository.this.name
  policy     = var.repository_lifecycle_policy
}