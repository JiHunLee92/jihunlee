################################################################################
# Cluster
################################################################################

variable "cluster_name" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
}

variable "logging" {
  type    = string
  default = "DEFAULT"
}

variable "setting_name" {
  type    = string
  default = "containerInsights"
}

variable "setting_value" {
  type    = string
  default = "enabled"
}

variable "terraform" {
  description = "Should be true to use Terraform"
  type        = bool
  default     = true
}

variable "environment" {
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

################################################################################
# Cluster Capacity Providers
################################################################################

variable "capacity_providers" {
  default = {}
}