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