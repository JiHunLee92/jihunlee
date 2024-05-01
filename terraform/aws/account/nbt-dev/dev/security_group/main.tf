#############################################################
# Security Group 
#############################################################

module "gateway_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.gateway_sg_rule

  name   = "${var.name}-${var.environment}-gateway-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-gateway-sg"
  }
}

module "redis_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.redis_sg_rule

  name   = "${var.name}-${var.environment}-redis-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-redis-sg"
  }
}

module "admin_alb_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.admin_alb_sg_rule

  name   = "${var.name}-${var.environment}-admin-alb-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-admin-alb-sg"
  }
}

module "admin_ecs_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.admin_ecs_sg_rule

  name   = "${var.name}-${var.environment}-admin-ecs-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-admin-ecs-sg"
  }
}

module "db_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.db_sg_rule

  name   = "${var.name}-${var.environment}-db-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-db-sg"
  }
}

module "eks_cluster_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.eks_cluster_sg_rule

  name   = "${var.name}-${var.environment}-eks-cluster-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-eks-cluster-sg"
  }
}

module "eks_node_group_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.eks_node_group_sg_rule

  name   = "${var.name}-${var.environment}-eks-node-group-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-eks-node-group-sg"
  }
}