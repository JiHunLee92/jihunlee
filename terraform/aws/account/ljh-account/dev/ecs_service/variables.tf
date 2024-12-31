################################################################################
# Service
################################################################################

variable "admin_family" {
  description = "A unique name for your task definition"
  type        = string
  default     = "admin"
}

variable "admin_network_mode" {
  description = "Docker networking mode to use for the containers in the task. Valid values are `none`, `bridge`, `awsvpc`, and `host`"
  type        = string
  default     = "awsvpc"
}

variable "admin_cpu" {
  description = "Number of cpu units used by the task. If the `requires_compatibilities` is `FARGATE` this field is required"
  type        = number
  default     = 512
}

variable "admin_memory" {
  description = "Amount (in MiB) of memory used by the task. If the `requires_compatibilities` is `FARGATE` this field is required"
  type        = number
  default     = 1024
}

variable "admin_skip_destroy" {
  description = "If true, the task is not deleted when the service is deleted"
  type        = bool
  default     = false
}

variable "admin_image_tag" {
  default = "dev-latest"
}

variable "admin_service_name" {
  description = "Name of the service (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = "admin"
}

variable "admin_deployment_maximum_percent" {
  description = "Upper limit (as a percentage of the service's `desired_count`) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "admin_deployment_minimum_healthy_percent" {
  description = "Lower limit (as a percentage of the service's `desired_count`) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 100
}

variable "admin_desired_count" {
  description = "Number of instances of the task definition to place and keep running. Defaults to `0`"
  type        = number
  default     = 1
}

variable "admin_health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers"
  type        = number
  default     = "0"
}

variable "admin_container_name" {
  default = "admin"
}

variable "admin_container_port" {
  default = 3000
}

variable "admin_assign_public_ip" {
  description = "Assign a public IP address to the ENI (Fargate launch type only)"
  type        = bool
  default     = false
}

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-2"
}

################################################################################
# Autoscaling
################################################################################

variable "admin_autoscaling_min_capacity" {
  default = 1
}

variable "admin_autoscaling_max_capacity" {
  default = 3
}

variable "admin_autoscaling_policies" {
  default = {
    cpu = {
      policy_type = "TargetTrackingScaling"

      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageCPUUtilization"
        }
      }
    }
    memory = {
      policy_type = "TargetTrackingScaling"

      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageMemoryUtilization"
        }

        scale_in_cooldown  = 300
        scale_out_cooldown = 70
        target_value       = 60
      }
    }
  }
}

variable "admin_autoscaling_scheduled_actions" {
  default = {
    SAT = {
      schedule   = "cron(0 0 4 ? * SAT *)"
      start_time = "2023-11-23T13:00:00+09:00"
      end_time   = "2100-11-23T13:00:00+09:00"
      timezone   = "Asia/Seoul"

      min_capacity = 2
      max_capacity = 10
    }
  }
}