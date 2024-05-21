###############################################################################
# CodeCommit
###############################################################################

variable "codecommit_name" {
  description = "The name of the codecommit"
  type        = string
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

# variable "codecommit_approval_rule_template_name" {
#   description = "The name of the codecommit approval rule template"
#   type        = string
# }

# variable "codecommit_approval_rule_content" {
#   type    = any
#   default = {}
# }