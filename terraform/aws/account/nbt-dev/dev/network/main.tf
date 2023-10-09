################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../../../module/network/"

  vpc_cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  external_nat_ip_ids    = var.external_nat_ip_ids
  enable_nat_gateway     = var.enable_nat_gateway

  name        = var.name
  environment = var.environment
}