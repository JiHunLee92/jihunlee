variable "project_id" {
  description = "The project ID to deploy into"
  type        = string
  default     = "test-project"
}

variable "region" {
  description = "The region to deploy into"
  type        = string
  default     = "asia-northeast3"
}

variable "lbs" {
  type = map(object({
    lb_name               = string
    load_balancing_scheme = string
    certificate_name      = optional(string, false)
    backend_services = map(object({
      bnd_name          = string
      protocol          = string
      port_name         = string
      health_check_name = string
      target_group_name = string
      security_policy   = optional(bool, false)
    }))
  }))
  default = {
    dev_lb = {
      lb_name               = "test-dev-lb"
      load_balancing_scheme = "EXTERNAL"
      backend_services = {
        bnd_docker = {
          bnd_name          = "test-dev-bnd-docker"
          protocol          = "HTTP"
          port_name         = "http"
          health_check_name = "http_health_check"
          target_group_name = "umig_docker"
          security_policy   = true
        }
        bnd_jenkins = {
          bnd_name          = "test-dev-bnd-jenkins"
          protocol          = "HTTP"
          port_name         = "jenkins"
          health_check_name = "jenkins_health_check"
          target_group_name = "umig_jenkins"
          security_policy   = true
        }
      }
    }
    dev_internal_lb = {
      lb_name               = "test-dev-internal-lb"
      load_balancing_scheme = "INTERNAL_MANAGED"
      backend_services      = {}
    }
  }
}