variable "zones" {
  description = "GCP 존"
  type        = string
  default     = "asia-northeast3-a,asia-northeast3-b,asia-northeast3-c"
}

variable "devops_cluster_name" {
  description = "생성할 GKE 클러스터의 이름"
  type        = string
  default     = "devops-dev-cluster-1-30-5"
}

variable "devops_project_id" {
  description = "GCP 프로젝트 ID"
  type        = string
  default     = "test-project"
}

variable "devops_ip_range_pods" {
  description = "secondary pod ip range"
  type        = string
  default     = "gke-pods"
}

variable "devops_ip_range_services" {
  description = "secondary service ip range"
  type        = string
  default     = "gke-services"
}

variable "http_load_balancing_t" {
  type    = bool
  default = true
}

variable "network_policy_f" {
  type    = bool
  default = false
}

variable "horizontal_pod_autoscaling_t" {
  type    = bool
  default = true
}

variable "filestore_csi_driver_f" {
  type    = bool
  default = false
}

variable "dns_cache_f" {
  type    = bool
  default = false
}

variable "devops_service_account" {
  description = "GKE 노드의 서비스 계정"
  type        = string
  default     = "test-dev-gke-default@test-project.iam.gserviceaccount.com"
}

variable "create_service_account_f" {
  description = "GKE 노드의 서비스 계정을 생성할지 여부"
  type        = bool
  default     = false
}

variable "deletion_protection_f" {
  description = "GKE 클러스터 삭제 보호 여부"
  type        = bool
  default     = false
}

variable "region" {
  description = "GCP 리전"
  type        = string
  default     = "asia-northeast3"
}

variable "devops_node_pools" {
  default = [
    {
      name               = "devops-node-pool"
      min_count          = 1
      max_count          = 2
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 20
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      logging_variant    = "DEFAULT"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    }
  ]
}

variable "machine_type" {
  description = "GKE 노드의 머신 타입"
  type        = string
  default     = "n1-standard-2"
}

variable "devops_node_pools_oauth_scopes" {
  description = "OAuth scopes for node pools"
  default = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

variable "node_pools_labels" {
  description = "Labels for node pools"
  default = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }
}

variable "node_pools_metadata" {
  description = "Metadata for node pools"
  default = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }
}

variable "node_pools_taints" {
  description = "Taints for node pools"
  default = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }
}

variable "node_pools_tags" {
  description = "Tags for node pools"
  default = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

variable "terraform_service_account" {
  description = "Terraform 서비스 계정"
  type        = string
  default     = "test-terrform-cloud@test-project.iam.gserviceaccount.com"
}

variable "GOOGLE_CREDENTIALS" {
  description = "The credentials to access Google Cloud"
  type        = string
  sensitive   = true
}

variable "TF_VAR_GOOGLE_CREDENTIALS" {
  description = "Environment variable for Google credentials"
  type        = string
  sensitive   = true
}