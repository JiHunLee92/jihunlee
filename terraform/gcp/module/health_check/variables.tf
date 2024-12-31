variable "project_id" {
  description = "Project id of the project that holds the network."
  type        = string
}

variable "health_check_name" {
  description = "The name of the health check"
  type        = string
}

variable "health_check_description" {
  description = "The description of the health check"
  type        = string
  default     = ""
}

variable "params" {
  description = "The parameters to use for the health check"
  type = map(object({
    port         = number
    request_path = optional(string)
  }))
}

# variable "port" {
#   description = "The port to use for the health check"
#   type        = number
# }

# variable "request_path" {
#   description = "The request path to use for the health check"
#   type        = string
#   default   = ""
# }

variable "timeout_sec" {
  description = "How long (in seconds) to wait for a response before considering the health check a failure"
  type        = number
  default     = 5
}

variable "check_interval_sec" {
  description = "How often (in seconds) to send a health check"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "How many successful checks before considering the instance healthy"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "How many failed checks before considering the instance unhealthy"
  type        = number
  default     = 2
}

# variable "tcp_health_checks" {
#   description = "A map of TCP health checks to create"
#   type        = object({
#     port = number
#   })
#   default     = {
#     port = 80
#   }
# }