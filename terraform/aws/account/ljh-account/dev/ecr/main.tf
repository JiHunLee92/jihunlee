################################################################################
# ECR Repository
################################################################################

module "admin_ecr" {
  source = "../../../../module/ecr"

  repository_name = "${var.name}-${var.environment}-ecr"
  repository_lifecycle_policy = templatefile("./templates/ecr_lifecycle_keep_30_images.json", {

  })
  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-ecr"
  }
}

# module "ecr" {
#   source = "../../../../module/ecr"

#   repository_name = "${var.name}-${var.environment}-ecr"
#   repository_lifecycle_policy = jsonencode({
#     rules = [
#       {
#         action = {
#           type = "expire"
#         },        
#         rulePriority = 1,
#         description  = "Keep last 30 images",
#         selection = {
#           countType     = "imageCountMoreThan",
#           countNumber   = 30,
#           tagStatus = "untagged"
#         }
#       }
#     ]
#   })

#   tags = {
#     Name = "${var.name}-${var.environment}-ecr"
#   }
# }