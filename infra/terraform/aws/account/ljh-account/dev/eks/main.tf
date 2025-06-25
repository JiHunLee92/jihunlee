################################################################################
# Cluster
################################################################################

module "eks_test_cluster" {
  source = "../../../../module/eks"

  cluster_name              = "${var.name}-${var.environment}-cluster"
  cluster_role_arn          = data.terraform_remote_state.iam.outputs.eks_cluster_role
  cluster_version           = var.test_cluster_version
  cluster_enabled_log_types = var.test_cluster_enabled_log_types

  authentication_mode                         = var.test_cluster_authentication_mode
  bootstrap_cluster_creator_admin_permissions = var.test_cluster_bootstrap_cluster_creator_admin_permissions

  cluster_additional_security_group_ids = [data.terraform_remote_state.sg.outputs.eks_cluster_sg]
  cluster_subnet_ids                    = concat(data.terraform_remote_state.vpc.outputs.public_subnets, data.terraform_remote_state.vpc.outputs.private_subnets)
  cluster_endpoint_private_access       = var.test_cluster_endpoint_private_access
  cluster_endpoint_public_access        = var.test_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs  = var.test_cluster_endpoint_public_access_cidrs

  kubernetes_network_config = var.test_cluster_kubernetes_network_config

  cluster_addons = var.test_cluster_addons

  cluster_tags = {
    Name = "${var.name}-${var.environment}-cluster"
  }

  #node_group
  node_group_name       = "${var.name}-${var.environment}-node-group"
  node_group_role_arn   = data.terraform_remote_state.iam.outputs.eks_node_group_role
  node_group_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  node_group_ami_type            = var.test_node_group_ami_type
  node_group_ami_release_version = var.test_node_group_ami_release_version
  node_group_capacity_type       = var.test_node_group_capacity_type
  node_group_disk_size           = var.test_node_group_disk_size
  node_group_instance_types      = var.test_node_group_instance_types

  node_group_force_update_version = var.test_node_group_force_update_version
  node_group_labels               = var.test_node_group_labels

  node_group_min_size     = var.test_node_group_min_size
  node_group_max_size     = var.test_node_group_max_size
  node_group_desired_size = var.test_node_group_desired_size

  node_group_remote_access = {
    ec2_ssh_key               = var.test_node_group_key_name
    source_security_group_ids = [data.terraform_remote_state.sg.outputs.eks_node_group_sg]
  }

  node_group_update_config = {
    max_unavailable = var.test_node_group_max_unavailable
  }

  environment = var.environment

  node_group_tags = {
    Name = "${var.name}-${var.environment}-node-group"
  }

  #access_entry 
  eks_access_entries = {
    access-1 = {
      principal_arn = data.aws_iam_user.lee_jihun_user_arn.arn
      type          = var.test_eks_access_entries_type
    }
  }

  eks_access_policy_association = {
    access-1 = {
      association_policy_arn        = var.cluster_admin_association_policy_arn
      association_principal_arn     = data.aws_iam_user.lee_jihun_user_arn.arn
      association_access_scope_type = var.test_association_access_scope_type
    }
  }
}