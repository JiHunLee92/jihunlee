##################################################################
# CloudWatch Log Group
##################################################################

variable "cloudwatch_log_group_name" {
  description = "A name for the log group"
  type        = string
  default     = null
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = null

  validation {
    condition     = var.retention_in_days == null ? true : contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.retention_in_days)
    error_message = "Must be 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653 or 0 (zero indicates never expire logs)."
  }
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
  description = "A map of tags to add to Cloudwatch log group"
  type        = map(string)
}