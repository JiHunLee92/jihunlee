################################################################################
# Repository 
################################################################################

output "admin_ecr_url" {
  value = module.admin_ecr.repository_url
}

output "admin_ecr_name" {
  value = module.admin_ecr.repository_name
}

output "admin_ecr_arns" {
  value = [module.admin_ecr.repository_arn]
}