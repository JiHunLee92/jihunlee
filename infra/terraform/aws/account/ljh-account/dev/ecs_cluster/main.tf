################################################################################
# Cluster
################################################################################

module "admin_cluster" {
  source = "../../../../module/ecs_cluster"

  cluster_name       = "${var.name}-${var.environment}-cluster"
  capacity_providers = var.test_capacity_providers

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-cluster"
  }
}