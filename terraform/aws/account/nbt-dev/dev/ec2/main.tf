################################################################################
# EC2 Module
################################################################################

module "gateway_ec2" {
  source = "../../../../module/ec2"

  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.gateway_instance_type
  availability_zone = var.gateway_availability_zone
  subnet_id         = element(data.terraform_remote_state.vpc.outputs.public_subnets, 0)

  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.gateway_sg]
  key_name               = var.key_name
  #iam_instance_profile = var.gateway_iam_instance_profile
  disable_api_termination = var.disable_api_termination

  root_block_device = var.gateway_root_block_device

  enable_ec2_eip = var.enable_gateway_eip
  instance       = module.gateway_ec2.instance_id

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-gateway"
  }
}

module "redis_ec2" {
  source = "../../../../module/ec2"

  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.redis_instance_type
  availability_zone = var.redis_availability_zone
  subnet_id         = element(data.terraform_remote_state.vpc.outputs.private_subnets, 0)

  vpc_security_group_ids  = [data.terraform_remote_state.sg.outputs.redis_sg]
  key_name                = var.key_name
  disable_api_termination = var.disable_api_termination

  root_block_device = var.redis_root_block_device
  # ebs_block_device  = var.redis_ebs_block_device

  enable_ec2_eip = var.enable_redis_eip

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-redis"
  }
}

module "db_ec2" {
  source = "../../../../module/ec2"

  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.db_instance_type
  availability_zone = var.db_availability_zone
  subnet_id         = element(data.terraform_remote_state.vpc.outputs.private_subnets, 0)

  vpc_security_group_ids  = [data.terraform_remote_state.sg.outputs.db_sg]
  key_name                = var.key_name
  disable_api_termination = var.disable_api_termination

  root_block_device = var.db_root_block_device
  # ebs_block_device  = var.redis_ebs_block_device

  enable_ec2_eip = var.enable_db_eip

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-db"
  }
}