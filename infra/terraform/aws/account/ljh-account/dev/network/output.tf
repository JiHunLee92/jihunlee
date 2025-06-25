# ###############################################################################
# VPC
# ###############################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

################################################################################
# Publiс Subnets
################################################################################

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

################################################################################
# Private Subnets
################################################################################

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}