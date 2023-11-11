################################################################################
# IAM Module
################################################################################


output "ecs_task_execution_role" {
  value = module.ecs_task_execution_role.iam_role_arn
}

output "ecs_task_role" {
  value = module.ecs_task_role.iam_role_arn
}