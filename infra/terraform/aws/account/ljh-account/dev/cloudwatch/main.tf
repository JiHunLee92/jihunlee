##################################################################
# CloudWatch Log Group
##################################################################

module "ecs_log_group" {
  source = "../../../../module/cloudwatch"

  cloudwatch_log_group_name = var.ecs_admin_name
  retention_in_days         = var.ecs_admin_retention_in_days

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-admin-log-group"
  }
}

module "eks_log_group" {
  source = "../../../../module/cloudwatch"

  cloudwatch_log_group_name = "/aws/eks/test-dev-cluster/cluster"
  retention_in_days         = var.eks_cluster_retention_in_days

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-eks-cluster-log-group"
  }
}