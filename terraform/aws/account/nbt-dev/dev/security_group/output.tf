#############################################################
# Security Group 
############################################################

output "gateway_sg" {
  value = module.gateway_sg.security_group_id
}

output "admin_alb_sg" {
  value = module.admin_alb_sg.security_group_id
}

output "admin_ecs_sg" {
  value = module.admin_ecs_sg.security_group_id
}

output "redis_sg" {
  value = module.redis_sg.security_group_id
}

output "db_sg" {
  value = module.db_sg.security_group_id
}