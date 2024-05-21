################################################################################
# Cluster
################################################################################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "test_cluster_version" {
  default = 1.29
}

variable "test_cluster_enabled_log_types" {
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

variable "test_cluster_kubernetes_network_config" {
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

################################################################################
# EKS Node Group
################################################################################

variable "test_node_group_ami_type" {
  default = "AL2_x86_64"
}

variable "test_node_group_ami_release_version" {
  default = "1.29.0-20240415"
}

variable "test_node_group_capacity_type" {
  default = "ON_DEMAND"
}

variable "test_node_group_disk_size" {
  default = "20"
}

variable "test_node_group_instance_types" {
  default = ["t3.medium"]
}

variable "test_node_group_force_update_version" {
  default = true
}

variable "test_node_group_labels" {
  type = map(string)
  default = {
    ENV = "dev"
  }
}

variable "test_node_group_min_size" {
  default = "2"
}

variable "test_node_group_max_size" {
  default = "2"
}

variable "test_node_group_desired_size" {
  default = "2"
}

variable "test_node_group_key_name" {
  default = "test-dev-key"
}

variable "test_node_group_max_unavailable" {
  default = "1"
}

################################################################################
# Access Entry
################################################################################

variable "test_eks_access_entries_type" {
  default = "STANDARD"
}

variable "cluster_admin_association_policy_arn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "test_association_access_scope_type" {
  default = "cluster"
}