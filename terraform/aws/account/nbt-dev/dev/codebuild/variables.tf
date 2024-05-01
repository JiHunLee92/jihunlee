###############################################################################
# CodeBuild
###############################################################################


variable "name" {
  default = "test"
  description = "The name of the default service"
}

variable "region" {
  default = "ap-northeast-2"
  description = "The region where the ECR repository is located"
}

variable "environment" {
  default = "dev"
  description = "The environment name"
}

variable "account_id" {
  default = "711111111"
  description = "The account ID where the ECR repository is located"
}

variable "codebuild_java_image" {
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:corretto11"
  description = "The Docker image for the build java11 environment"
}

variable "svc_test" {
  default = "test"
  description = "The service name"
}

variable "source_branch" {
  default = "develop"
}

