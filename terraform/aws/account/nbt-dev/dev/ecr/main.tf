################################################################################
# ECR Repository
################################################################################

# module "ecr" {
#   source = "../.."

#   repository_name = "${var.name}-${var.environment}-ecr"
#   repository_lifecycle_policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1,
#         description  = "Keep last 30 images",
#         selection = {
#           tagStatus     = "tagged",
#           tagPrefixList = ["v"],
#           countType     = "imageCountMoreThan",
#           countNumber   = 30
#         },
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })

#   tags = {
#     Name = "${var.name}-${var.environment}-ecr"
#   }
# }