################################################################################
# Cluster
################################################################################

output "arn" {
  description = "ARN that identifies the cluster"
  value       = try(aws_ecs_cluster.this.arn, null)
}

output "id" {
  description = "ID that identifies the cluster"
  value       = try(aws_ecs_cluster.this.id, null)
}

output "name" {
  description = "Name that identifies the cluster"
  value       = try(aws_ecs_cluster.this.name, null)
}