################################################################################
# IAM 
################################################################################

variable "assume_role_policy" {
  type = string
}

variable "role_name" {
  type = string
}

variable "aws_iam_role_policy_attachment" {}

variable "aws_iam_role_policy" {}

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

variable "aws_iam_instance_profile" {
  type = map(object({
    instance_profile_name = string
  }))
}