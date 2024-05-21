#############################################################
# Security Group 
#############################################################

module "gateway_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.gateway_sg_rule

  sg_name = "${var.name}-${var.environment}-gateway-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-gateway-sg"
  }
}

module "redis_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.redis_sg_rule

  sg_name = "${var.name}-${var.environment}-redis-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-redis-sg"
  }
}

module "admin_alb_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.admin_alb_sg_rule

  sg_name = "${var.name}-${var.environment}-admin-alb-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-admin-alb-sg"
  }
}

module "admin_ecs_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.admin_ecs_sg_rule

  sg_name = "${var.name}-${var.environment}-admin-ecs-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-admin-ecs-sg"
  }
}

module "db_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.db_sg_rule

  sg_name = "${var.name}-${var.environment}-db-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-db-sg"
  }
}

module "eks_cluster_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.eks_cluster_sg_rule

  sg_name = "${var.name}-${var.environment}-eks-cluster-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-eks-cluster-sg"
  }
}

module "eks_node_group_sg" {
  source = "../../../../module/security_group"

  sg_rule = var.eks_node_group_sg_rule

  sg_name = "${var.name}-${var.environment}-eks-node-group-sg"
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-eks-node-group-sg"
  }
}

# EX
# module "test_redis_sg" {
#   depends_on = [module.gateway_sg]
#   source = "../../../../module/security_group/"

#   sg_rule = {
#     ingress-1 = {
#       rule_type  = "ingress"
#       from_port  = 22
#       to_port    = 22
#       protocol   = "tcp"
#       src_or_dst = module.gateway_sg.security_group_id
#     },
#     ingress-2 = {
#       rule_type  = "ingress"
#       from_port  = 6379
#       to_port    = 6379
#       protocol   = "tcp"
#       src_or_dst = module.app_sg.security_group_id
#     },
#     ingress-3 = {
#       rule_type  = "ingress"
#       from_port  = 6379
#       to_port    = 6379
#       protocol   = "tcp"
#       src_or_dst = "self"
#     },
#     egress-1 = {
#       rule_type  = "egress"
#       from_port  = 0
#       to_port    = 0
#       protocol   = "-1"
#       src_or_dst = "0.0.0.0/0"
#     }
#   }

#   name   = "${var.name}-${var.environment}-redis-sg"
#   vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

#   environment = var.environment

#   tags = {
#     Name = "${var.name}-${var.environment}-redis-sg"
#   }
# }