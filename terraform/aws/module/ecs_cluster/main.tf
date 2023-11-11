################################################################################
# Cluster
################################################################################

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  configuration {
    execute_command_configuration {
      logging = var.logging
    }
  }

  setting {
    name  = var.setting_name
    value = var.setting_value
  }

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )
}

################################################################################
# Cluster Capacity Providers
################################################################################

resource "aws_ecs_cluster_capacity_providers" "this" {

  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = var.capacity_providers
}