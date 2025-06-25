################################################################################
# Target Group(s)
################################################################################

output "admin_target_group" {
  description = "Map of target groups created and their attributes"
  value       = module.test_admin_alb.target_groups
}