variable "project_id" {
  description = "Project id of the project that holds the network."
  type        = string
  default     = "test-project"
}

variable "region" {
  description = "The region to deploy into"
  default     = "asia-northeast3"
}

# variable "zone" {
#   description = "The zone to deploy into"
#   default     = "asia-northeast3-a"
# }

variable "tcp_health_checks" {
  description = "A map of TCP health checks to create"
  type = map(object({
    name = string
    port = number
  }))
  default = {
    tcp_80_health_check = {
      name = "test-dev-80-tcp-health-check"
      port = 80
    }
  }
}

variable "http_health_checks" {
  description = "A map of HTTP health checks to create"
  type = map(object({
    name         = string
    port         = number
    request_path = string
  }))
  default = {
    http_health_check = {
      name         = "test-dev-http-health-check"
      port         = 80
      request_path = "/"
    }
    jenkins_health_check = {
      name         = "test-dev-jenkins-health-check"
      port         = 8080
      request_path = "/login"
    }
  }
}