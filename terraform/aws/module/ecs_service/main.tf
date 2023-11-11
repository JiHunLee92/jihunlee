################################################################################
# Task Definition
################################################################################

resource "aws_ecs_task_definition" "this" {

  family                   = var.family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = var.tasks_iam_role_arn
  execution_role_arn       = var.task_exec_iam_role_arn
  skip_destroy             = var.skip_destroy

  #   container_definitions = jsonencode([for k, v in module.container_definition : v.container_definition])
  container_definitions = var.container_definitions

  dynamic "volume" {
    for_each = var.volume

    content {
      dynamic "docker_volume_configuration" {
        for_each = try([volume.value.docker_volume_configuration], [])

        content {
          autoprovision = try(docker_volume_configuration.value.autoprovision, null)
          driver        = try(docker_volume_configuration.value.driver, null)
          driver_opts   = try(docker_volume_configuration.value.driver_opts, null)
          labels        = try(docker_volume_configuration.value.labels, null)
          scope         = try(docker_volume_configuration.value.scope, null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = try([volume.value.efs_volume_configuration], [])

        content {
          dynamic "authorization_config" {
            for_each = try([efs_volume_configuration.value.authorization_config], [])

            content {
              access_point_id = try(authorization_config.value.access_point_id, null)
              iam             = try(authorization_config.value.iam, null)
            }
          }

          file_system_id          = efs_volume_configuration.value.file_system_id
          root_directory          = try(efs_volume_configuration.value.root_directory, null)
          transit_encryption      = try(efs_volume_configuration.value.transit_encryption, null)
          transit_encryption_port = try(efs_volume_configuration.value.transit_encryption_port, null)
        }
      }
      name = try(volume.value.name, volume.key)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Service
################################################################################

resource "aws_ecs_service" "this" {
  count = 1

  name                               = var.name
  cluster                            = var.cluster_arn
  task_definition                    = aws_ecs_task_definition.this.arn
  scheduling_strategy                = var.scheduling_strategy
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  enable_execute_command             = var.enable_execute_command
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  launch_type                        = var.launch_type

  dynamic "deployment_circuit_breaker" {
    for_each = length(var.deployment_circuit_breaker) > 0 ? [var.deployment_circuit_breaker] : []

    content {
      enable   = deployment_circuit_breaker.value.enable
      rollback = deployment_circuit_breaker.value.rollback
    }
  }

  dynamic "deployment_controller" {
    for_each = length(var.deployment_controller) > 0 ? [var.deployment_controller] : []

    content {
      type = try(deployment_controller.value.type, null)
    }
  }

  dynamic "load_balancer" {
    # Set by task set if deployment controller is external
    for_each = { for k, v in var.load_balancer : k => v }

    content {
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
      target_group_arn = try(load_balancer.value.target_group_arn, null)
    }
  }

  dynamic "network_configuration" {
    # Set by task set if deployment controller is external
    for_each = var.network_mode == "awsvpc" ? [{ for k, v in var.network_configuration : k => v }] : []

    content {
      assign_public_ip = network_configuration.value.assign_public_ip
      security_groups  = network_configuration.value.security_groups
      subnets          = network_configuration.value.subnets
    }
  }

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.service_tags
  )

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  lifecycle {
    ignore_changes = [
      desired_count, # Always ignored
    ]
  }
}

################################################################################
# Autoscaling
################################################################################

# locals {
#   enable_autoscaling = var.create && var.enable_autoscaling && !local.is_daemon

#   cluster_name = element(split("/", var.cluster_arn), 1)
# }

# resource "aws_appautoscaling_target" "this" {
#   count = local.enable_autoscaling ? 1 : 0

#   # Desired needs to be between or equal to min/max
#   min_capacity = min(var.autoscaling_min_capacity, var.desired_count)
#   max_capacity = max(var.autoscaling_max_capacity, var.desired_count)

#   resource_id        = "service/${local.cluster_name}/${try(aws_ecs_service.this[0].name, aws_ecs_service.ignore_task_definition[0].name)}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "this" {
#   for_each = { for k, v in var.autoscaling_policies : k => v if local.enable_autoscaling }

#   name               = try(each.value.name, each.key)
#   policy_type        = try(each.value.policy_type, "TargetTrackingScaling")
#   resource_id        = aws_appautoscaling_target.this[0].resource_id
#   scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this[0].service_namespace

#   dynamic "step_scaling_policy_configuration" {
#     for_each = try([each.value.step_scaling_policy_configuration], [])

#     content {
#       adjustment_type          = try(step_scaling_policy_configuration.value.adjustment_type, null)
#       cooldown                 = try(step_scaling_policy_configuration.value.cooldown, null)
#       metric_aggregation_type  = try(step_scaling_policy_configuration.value.metric_aggregation_type, null)
#       min_adjustment_magnitude = try(step_scaling_policy_configuration.value.min_adjustment_magnitude, null)

#       dynamic "step_adjustment" {
#         for_each = try(step_scaling_policy_configuration.value.step_adjustment, [])

#         content {
#           metric_interval_lower_bound = try(step_adjustment.value.metric_interval_lower_bound, null)
#           metric_interval_upper_bound = try(step_adjustment.value.metric_interval_upper_bound, null)
#           scaling_adjustment          = try(step_adjustment.value.scaling_adjustment, null)
#         }
#       }
#     }
#   }

#   dynamic "target_tracking_scaling_policy_configuration" {
#     for_each = try(each.value.policy_type, null) == "TargetTrackingScaling" ? try([each.value.target_tracking_scaling_policy_configuration], []) : []

#     content {
#       dynamic "customized_metric_specification" {
#         for_each = try([target_tracking_scaling_policy_configuration.value.customized_metric_specification], [])

#         content {
#           dynamic "dimensions" {
#             for_each = try(customized_metric_specification.value.dimensions, [])

#             content {
#               name  = dimensions.value.name
#               value = dimensions.value.value
#             }
#           }

#           metric_name = customized_metric_specification.value.metric_name
#           namespace   = customized_metric_specification.value.namespace
#           statistic   = customized_metric_specification.value.statistic
#           unit        = try(customized_metric_specification.value.unit, null)
#         }
#       }

#       disable_scale_in = try(target_tracking_scaling_policy_configuration.value.disable_scale_in, null)

#       dynamic "predefined_metric_specification" {
#         for_each = try([target_tracking_scaling_policy_configuration.value.predefined_metric_specification], [])

#         content {
#           predefined_metric_type = predefined_metric_specification.value.predefined_metric_type
#           resource_label         = try(predefined_metric_specification.value.resource_label, null)
#         }
#       }

#       scale_in_cooldown  = try(target_tracking_scaling_policy_configuration.value.scale_in_cooldown, 300)
#       scale_out_cooldown = try(target_tracking_scaling_policy_configuration.value.scale_out_cooldown, 60)
#       target_value       = try(target_tracking_scaling_policy_configuration.value.target_value, 75)
#     }
#   }
# }

# resource "aws_appautoscaling_scheduled_action" "this" {
#   for_each = { for k, v in var.autoscaling_scheduled_actions : k => v if local.enable_autoscaling }

#   name               = try(each.value.name, each.key)
#   service_namespace  = aws_appautoscaling_target.this[0].service_namespace
#   resource_id        = aws_appautoscaling_target.this[0].resource_id
#   scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension

#   scalable_target_action {
#     min_capacity = each.value.min_capacity
#     max_capacity = each.value.max_capacity
#   }

#   schedule   = each.value.schedule
#   start_time = try(each.value.start_time, null)
#   end_time   = try(each.value.end_time, null)
#   timezone   = try(each.value.timezone, null)
# }