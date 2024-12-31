###############################################################################
# CodeCommit
###############################################################################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "test_codecommit_approval_rule_template_name" {
  default = "Require approvals before merge"
}