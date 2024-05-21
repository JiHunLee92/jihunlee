##################################################################
# Elastic Load Balancer
##################################################################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "load_balancer_type_alb" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

variable "load_balancer_type_nlb" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "network"
}

variable "internal_t" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = true
}

variable "internal_f" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = false
}

variable "idle_timeout_60" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

# variable "admin_target_group_attachments" {

#   default = {
#     tg_index = "admin-target-group"
#     target_id = data.terraform_remote_state.ec2.outputs.gateway_ec2_id
#     prot = 80
#     # availability_zone =
#   }
# }