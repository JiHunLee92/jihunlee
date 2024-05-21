################################################################################
# EC2
# Link : https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
################################################################################

resource "aws_instance" "this" {
  count = 1

  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  subnet_id         = var.subnet_id

  vpc_security_group_ids  = var.vpc_security_group_ids
  key_name                = var.key_name
  iam_instance_profile    = var.iam_instance_profile
  disable_api_termination = var.disable_api_termination

  dynamic "root_block_device" {
    for_each = var.root_block_device

    content {
      delete_on_termination = try(root_block_device.value.delete_on_termination, null)
      iops                  = try(root_block_device.value.iops, null)
      volume_size           = try(root_block_device.value.volume_size, null)
      volume_type           = try(root_block_device.value.volume_type, null)
      throughput            = try(root_block_device.value.throughput, null)
      tags                  = try(root_block_device.value.tags, null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      iops                  = try(ebs_block_device.value.iops, null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
    }
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
# EIP
################################################################################

resource "aws_eip" "this" {
  count = var.enable_ec2_eip ? 1 : 0

  instance = var.instance
  domain   = "vpc"

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )

  depends_on = [
    aws_instance.this
  ]
}