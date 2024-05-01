################################################################################
# Cluster
################################################################################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "eks_test_cluster_version" {
  default = 1.29
}

variable "test_enabled_cluster_log_types" {
  type    = list(string)
  default = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
}

variable "test_cluster_authentication_mode" {
  description = "The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "test_cluster_bootstrap_cluster_creator_admin_permissions" {
  type    = bool
  default = false
}

variable "test_cluster_endpoint_private_access" {
  default = true
}

variable "test_cluster_endpoint_public_access" {
  default = true
}

variable "test_cluster_endpoint_public_access_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "test_kubernetes_network_config" {
  default = {
    config-1 = {
      ip_family         = "ipv4"
      service_ipv4_cidr = "172.20.0.0/16"
    }
  }
}

variable "test_cluster_addons" {
  default = {
    coredns = {
      addon_version               = "v1.11.1-eksbuild.6"
      resolve_conflicts_on_update = "PRESERVE"
    },
    kube-proxy = {
      addon_version               = "v1.29.0-eksbuild.1"
      resolve_conflicts_on_update = "PRESERVE"
    },
    vpc-cni = {
      addon_version               = "v1.16.0-eksbuild.1"
      resolve_conflicts_on_update = "PRESERVE"
    },
    eks-pod-identity-agent = {
      addon_version               = "v1.2.0-eksbuild.1"
      resolve_conflicts_on_update = "PRESERVE"
    }
  }
}

variable "region" {
  default = "ap-northeast-2"
}