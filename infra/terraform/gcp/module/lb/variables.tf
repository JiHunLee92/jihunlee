variable "project_id" {
  description = "The project to deploy into"
  type        = string
}

variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme to use for the load balancer"
  type        = string
}

variable "certificate_name" {
  description = "The name of the certificate to use for the load balancer"
  type        = string
  default     = null
}

variable "backend_services" {
  description = "A map of backend services to create"
  type = map(object({
    bnd_name        = string
    protocol        = string
    port_name       = string
    health_check_id = string
    target_group_id = string
    security_policy = optional(string)
  }))
}

# variable "bnd_name" {
#   description = "The name of the backend service"
#   type        = string
# }

# variable "protocol" {
#   description = "The protocol to use for the backend service"
#   type        = string
#   default     = "HTTP"
# }

# variable "port_name" {
#   description = "The name of the port to use for the backend service"
#   type        = string
#   default     = "http"
# }

# variable "health_check_id" {
#   description = "The health check to use for the backend service"
#   type        = string
# }

variable "timeout_sec" {
  description = "How long (in seconds) to wait for a response before considering the health check a failure"
  type        = number
  default     = 10
}

# variable "target_group_id" {
#   description = "The target group to use for the backend service"
#   type        = string
# }

# variable "security_policy" {
#   description = "The security policy to use for the backend service"
#   type        = string
#   default     = null
# }

# variable "default_service" {
#   description = "The default service to use for the load balancer"
#   type        = string
# }