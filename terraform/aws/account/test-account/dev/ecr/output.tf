################################################################################
# Repository 
################################################################################

output "admin_ecr_url" {
  value = module.admin_ecr.repository_url
}

# EX
# output "test_ecr_arns" {
#   value = [module.admin_repo.repository_arn, module.web_repo.repository_arn]
# }

# output "test_ecr_repository_urls" {
#   value = [module.admin_repo.repository_url, module.web_repo.repository_url]
# }

# output "test_ecr_repository_name" {
#   value = module.admin_repo.repository_name
# }