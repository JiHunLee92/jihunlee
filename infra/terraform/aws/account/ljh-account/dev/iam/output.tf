################################################################################
# IAM Module
################################################################################

output "ecs_task_execution_role" {
  value = module.ecs_task_execution_role.iam_role_arn
}

output "ecs_task_role" {
  value = module.ecs_task_role.iam_role_arn
}

output "eks_cluster_role" {
  value = module.eks_cluster_role.iam_role_arn
}

output "eks_node_group_role" {
  value = module.eks_node_group_role.iam_role_arn
}

output "codebuild_role" {
  value = module.codebuild_role.iam_role_arn
}