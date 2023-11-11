#################
# Security group
#################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "gateway_sg_rule" {
  default = {
    ingres-1 = {
      rule_type  = "ingress"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      src_or_dst = "10.14.0.0/16"
    },
    ingress-2 = {
      rule_type  = "ingress"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      src_or_dst = "35.200.70.193/32"
    },
    ingress-3 = {
      rule_type   = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      src_or_dst  = "1.235.219.252/32"
      description = "majestarcity_dev"
    },
    ingress-4 = {
      rule_type   = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      src_or_dst  = "172.16.0.0/32"
      description = "SSL_VPN"
    },
    egress-1 = {
      rule_type  = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      src_or_dst = "0.0.0.0/0"
    }
  }
}

variable "redis_sg_rule" {
  default = {
    ingres-1 = {
      rule_type  = "ingress"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      src_or_dst = "0.0.0.0/0"
    },
    ingres-2 = {
      rule_type  = "ingress"
      from_port  = 6379
      to_port    = 6379
      protocol   = "tcp"
      src_or_dst = "0.0.0.0/0"
    },
    egress-1 = {
      rule_type  = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      src_or_dst = "0.0.0.0/0"
    }
  }
}

variable "admin_alb_sg_rule" {
  default = {
    ingres-1 = {
      rule_type  = "ingress"
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      src_or_dst = "0.0.0.0/0"
    },
    ingres-2 = {
      rule_type  = "ingress"
      from_port  = 443
      to_port    = 443
      protocol   = "tcp"
      src_or_dst = "0.0.0.0/0"
    },
    egress-1 = {
      rule_type  = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      src_or_dst = "0.0.0.0/0"
    }
  }
}

variable "admin_ecs_sg_rule" {
  default = {
    ingres-1 = {
      rule_type  = "ingress"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      src_or_dst = "0.0.0.0/0"
    },
    egress-1 = {
      rule_type  = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      src_or_dst = "0.0.0.0/0"
    }
  }
}

variable "db_sg_rule" {
  default = {
    ingres-1 = {
      rule_type  = "ingress"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      src_or_dst = "0.0.0.0/0"
    },
    ingres-2 = {
      rule_type  = "ingress"
      from_port  = 3306
      to_port    = 3306
      protocol   = "tcp"
      src_or_dst = "0.0.0.0/0"
    },
    egress-1 = {
      rule_type  = "egress"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      src_or_dst = "0.0.0.0/0"
    }
  }
}