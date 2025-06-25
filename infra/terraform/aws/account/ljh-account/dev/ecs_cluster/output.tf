################################################################################
# Cluster
################################################################################

output "admin_cluster" {
  value = module.admin_cluster.arn
}

output "admin_cluster_name" {
  value = module.admin_cluster.name
}