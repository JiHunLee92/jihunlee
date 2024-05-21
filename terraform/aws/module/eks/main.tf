################################################################################
# Cluster
# Link : https://github.com/terraform-aws-modules/terraform-aws-eks
################################################################################

resource "aws_eks_cluster" "this" {
  count = 1

  name                      = var.cluster_name
  role_arn                  = var.cluster_role_arn
  version                   = var.cluster_version
  enabled_cluster_log_types = var.cluster_enabled_log_types

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    security_group_ids      = var.cluster_additional_security_group_ids
    subnet_ids              = var.cluster_subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  dynamic "kubernetes_network_config" {
    for_each = { for k, v in var.kubernetes_network_config : k => v }

    content {
      ip_family         = kubernetes_network_config.value.ip_family
      service_ipv4_cidr = kubernetes_network_config.value.service_ipv4_cidr
    }
  }

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.cluster_tags
  )
}

################################################################################
# EKS Addons
################################################################################

resource "aws_eks_addon" "this" {
  for_each = { for k, v in var.cluster_addons : k => v }

  cluster_name = aws_eks_cluster.this[0].name
  addon_name   = try(each.value.name, each.key)

  addon_version               = try(each.value.addon_version, null)
  configuration_values        = try(each.value.configuration_values, null)
  preserve                    = try(each.value.preserve, null)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, "OVERWRITE")
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, "OVERWRITE")
  service_account_role_arn    = try(each.value.service_account_role_arn, null)

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.addon_tags
  )
}

################################################################################
# EKS Node Group
################################################################################

resource "aws_eks_node_group" "this" {
  count = 1

  cluster_name = aws_eks_cluster.this[0].name
  version      = aws_eks_cluster.this[0].version

  node_group_name = var.node_group_name
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.node_group_subnet_ids

  ami_type        = var.node_group_ami_type
  release_version = var.node_group_ami_release_version
  capacity_type   = var.node_group_capacity_type
  disk_size       = var.node_group_use_custom_launch_template ? null : var.node_group_disk_size # if using a custom LT, set disk size on custom LT or else it will error here
  instance_types  = var.node_group_instance_types

  force_update_version = var.node_group_force_update_version
  labels               = var.node_group_labels

  scaling_config {
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
    desired_size = var.node_group_desired_size
  }

  dynamic "launch_template" {
    for_each = var.node_group_use_custom_launch_template ? [1] : []

    content {
      id      = try(launch_template_id, null)
      version = try(launch_template_version, null)
    }
  }

  dynamic "remote_access" {
    for_each = length(var.node_group_remote_access) > 0 ? [var.node_group_remote_access] : []

    content {
      ec2_ssh_key               = try(remote_access.value.ec2_ssh_key, null)
      source_security_group_ids = try(remote_access.value.source_security_group_ids, [])
    }
  }

  dynamic "taint" {
    for_each = var.node_group_taints

    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  dynamic "update_config" {
    for_each = length(var.node_group_update_config) > 0 ? [var.node_group_update_config] : []

    content {
      max_unavailable_percentage = try(update_config.value.max_unavailable_percentage, null)
      max_unavailable            = try(update_config.value.max_unavailable, null)
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.node_group_tags
  )
}

################################################################################
# Access Entry
################################################################################

resource "aws_eks_access_entry" "this" {
  for_each = var.eks_access_entries

  cluster_name      = aws_eks_cluster.this[0].name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = try(each.value.kubernetes_groups, null)
  type              = try(each.value.type, "STANDARD")
  user_name         = try(each.value.user_name, null)
}

resource "aws_eks_access_policy_association" "this" {
  for_each = var.eks_access_policy_association

  cluster_name  = aws_eks_cluster.this[0].name
  policy_arn    = each.value.association_policy_arn
  principal_arn = each.value.association_principal_arn

  access_scope {
    namespaces = try(each.value.association_access_scope_namespaces, [])
    type       = each.value.association_access_scope_type
  }

  depends_on = [
    aws_eks_access_entry.this,
  ]
}