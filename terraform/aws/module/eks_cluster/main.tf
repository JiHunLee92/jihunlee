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
    subnet_ids              = var.subnet_ids
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
    var.tags
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