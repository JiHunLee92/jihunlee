##################################################################
# CloudWatch Log Group
##################################################################

variable "ecs_admin_name" {
  default = "/ecs/test-dev-admin"
}

variable "ecs_admin_retention_in_days" {
  default = "180"
}

variable "environment" {
  default = "dev"
}

variable "name" {
  default = "test"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "eks_cluster_retention_in_days" {
  default = "180"
}