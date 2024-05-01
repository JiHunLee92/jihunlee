################################################################################
# Cluster
################################################################################

module "eks_test_cluster" {
  source = "../../../../module/eks_cluster"

  cluster_name              = "${var.name}-${var.environment}-cluster"
  cluster_role_arn          = data.terraform_remote_state.iam.outputs.eks_cluster_role
  cluster_version           = var.eks_test_cluster_version
  cluster_enabled_log_types = var.test_enabled_cluster_log_types

  authentication_mode                         = var.test_cluster_authentication_mode
  bootstrap_cluster_creator_admin_permissions = var.test_cluster_bootstrap_cluster_creator_admin_permissions

  cluster_additional_security_group_ids = [data.terraform_remote_state.sg.outputs.eks_cluster_sg]
  subnet_ids                            = concat(data.terraform_remote_state.vpc.outputs.public_subnets,data.terraform_remote_state.vpc.outputs.private_subnets)
  cluster_endpoint_private_access       = var.test_cluster_endpoint_private_access
  cluster_endpoint_public_access        = var.test_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs  = var.test_cluster_endpoint_public_access_cidrs

  kubernetes_network_config = var.test_kubernetes_network_config

  cluster_addons = var.test_cluster_addons

  tags = {
    Name = "${var.name}-${var.environment}-cluster"
  }
}
