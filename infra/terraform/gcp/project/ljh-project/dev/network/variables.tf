variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
  default     = "test-project"
}

variable "region" {
  description = "The GCP region where resources will be deployed"
  type        = string
  default     = "asia-northeast3"
}

variable "shared_vpc_host" {
  description = "The name of the shared VPC host project"
  type        = string
  default     = true
}

variable "environment" {
  description = "The name of the environment"
  type        = string
  default     = "dev"
}