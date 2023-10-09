#############################################################
# Security Group 
############################################################

output "gateway_sg" {
  value = module.gateway_sg.security_group_id
}