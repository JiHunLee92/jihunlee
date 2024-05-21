output "network" {
  value       = module.vpc.network
  description = "The VPC resource being created"
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "public_subnets" {
  value       = module.vpc.subnets["asia-northeast3/test-dev-sbn-public"]
  description = "The created subnet resources"
}

output "private_subnets" {
  value       = module.vpc.subnets["asia-northeast3/test-dev-sbn-private"]
  description = "The created subnet resources"
}

output "internal_subnets" {
  value       = module.vpc.subnets["asia-northeast3/test-dev-sbn-internal"]
  description = "The created subnet resources"
}
