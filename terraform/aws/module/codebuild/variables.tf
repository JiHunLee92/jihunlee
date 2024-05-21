################################################################################
# Repository
################################################################################

variable "codebuild_name" {
  description = "The name of the codebuild project"
  type        = string
}

variable "codebuild_role_arn" {
  description = "The ARN of the IAM role that allows CodeBuild to interact with dependent AWS services"
  type        = string
}

variable "compute_type" {
  description = "The compute type for the build"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "image" {
  description = "The Docker image for the build environment"
  type        = string
  default     = "aws/codebuild/standard:4.0"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = ""
}

variable "source_repo" {
  description = "The URL of the source repository"
  type        = string
  default     = ""
}

variable "source_branch" {
  description = "The branch of the source repository"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region where the ECR repository is located"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "The account ID where the ECR repository is located"
  type        = string
  default     = ""
}

variable "terraform" {
  description = "Should be true to use Terraform"
  type        = bool
  default     = true
}

variable "environment" {
  type    = string
  default = ""
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

################################################################################
# CodeBuild Webhook
################################################################################
