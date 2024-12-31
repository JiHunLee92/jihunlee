###############################################################################
# CodeBuild
###############################################################################

variable "name" {
  default     = "test"
  description = "The name of the default service"
}

variable "environment" {
  default     = "dev"
  description = "The environment name"
}

variable "region" {
  default     = "ap-northeast-2"
  description = "The region where the ECR repository is located"
}

variable "account_id" {
  default     = "111111111111"
  description = "The account ID where the ECR repository is located"
}

variable "source_branch" {
  default = "develop"
}