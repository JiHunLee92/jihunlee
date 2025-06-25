################################################################################
# Cluster
################################################################################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "test_capacity_providers" {
  default = ["FARGATE"]
}