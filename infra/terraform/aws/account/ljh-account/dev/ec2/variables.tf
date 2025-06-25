################################################################################
# EC2
################################################################################

variable "gateway_instance_type" {
  default = "t2.micro"
}

variable "gateway_availability_zone" {
  default = "ap-northeast-2a"
}

variable "key_name" {
  default = "test-dev-key"
}

variable "disable_api_termination" {
  default = "false"
}

variable "gateway_root_block_device" {
  default = {
    root_block_device = {
      delete_on_termination = "true"
      iops                  = "3000"
      volume_size           = 16
      volume_type           = "gp3"
      throughput            = 125
      tags = {
        Name = "test-dev-gateway-root-device"
      }
    }
  }
}

variable "enable_gateway_eip" {
  default = true
}

variable "redis_instance_type" {
  default = "t3.small"
}

variable "redis_availability_zone" {
  default = "ap-northeast-2a"
}

variable "redis_root_block_device" {
  default = {
    root_block_device = {
      delete_on_termination = "true"
      iops                  = "3000"
      volume_size           = 16
      volume_type           = "gp3"
      throughput            = 125
      tags = {
        Name = "test-dev-redis-root-device"
      }
    }
  }
}

# variable "redis_ebs_block_device" {
#   default = {
#     ebs_block_device = {
#       delete_on_termination = "true"
#       device_name           = "/dev/sdf"
#       iops                  = "3000"
#       volume_size           = 16
#       volume_type           = "gp3"
#       throughput            = 125
#       tags = {
#         Name = "test-dev-redis-ebs-device"
#       }
#     }
#   }
# }

variable "enable_redis_eip" {
  default = false
}

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "db_instance_type" {
  default = "t3.small"
}

variable "db_availability_zone" {
  default = "ap-northeast-2a"
}

variable "db_root_block_device" {
  default = {
    root_block_device = {
      delete_on_termination = "true"
      iops                  = "3000"
      volume_size           = 16
      volume_type           = "gp3"
      throughput            = 125
      tags = {
        Name = "test-dev-db-root-device"
      }
    }
  }
}

variable "enable_db_eip" {
  default = false
}