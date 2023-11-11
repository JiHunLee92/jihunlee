################################################################################
# Service
################################################################################

module "ecs_service_admin" {
  source = "../../../../module/ecs_service"

  family                 = var.admin_family
  network_mode           = var.admin_network_mode
  cpu                    = var.admin_cpu
  memory                 = var.admin_memory
  tasks_iam_role_arn     = data.terraform_remote_state.iam.outputs.ecs_task_role
  task_exec_iam_role_arn = data.terraform_remote_state.iam.outputs.ecs_task_execution_role
  skip_destroy           = var.admin_skip_destroy

  container_definitions = templatefile("./templates/container_definition_admin.json", {
    image = "${data.terraform_remote_state.ecr.outputs.admin_ecr_url}:${var.admin_image_tag}"
    awslogs-group                        = "${aws_cloudwatch_log_group.test.name}"
    awslogs-region                       = var.region
    # secrets-DATABASE_PASSWORD = "${data.aws_ssm_parameter.db-password-parameter.arn}"
    # secrets-DATABASE_USER     = "${data.aws_ssm_parameter.db-username-parameter.arn}"
  })

  name                               = var.admin_name
  cluster_arn                        = data.terraform_remote_state.cluster.outputs.admin_cluster
  deployment_maximum_percent         = var.admin_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.admin_deployment_minimum_healthy_percent
  desired_count                      = var.admin_desired_count
  health_check_grace_period_seconds  = var.admin_health_check_grace_period_seconds

  deployment_circuit_breaker = {
    enable   = "true"
    rollback = "true"
  }

  load_balancer = {
    service = {
      target_group_arn = data.terraform_remote_state.elb.outputs.admin_target_group
      container_name   = var.admin_container_name
      container_port   = var.admin_container_port
    }
  }

  network_configuration = {
    assign_public_ip = var.admin_assign_public_ip
    security_groups  = [data.terraform_remote_state.sg.outputs.admin_ecs_sg]
    subnets          = data.terraform_remote_state.vpc.outputs.private_subnets
  }

  service_tags = {
    Name = "${var.name}-${var.environment}-admin-service"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "test" {
  name              = "/ecs/test-dev-admin"
  retention_in_days = "180"
}