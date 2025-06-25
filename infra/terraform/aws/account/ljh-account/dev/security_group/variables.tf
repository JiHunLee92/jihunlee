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
      src_or_dst = "0.0.0.0/0"
    },
    ingress-2 = {
      rule_type  = "ingress"
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      src_or_dst = "1.1.1.1/32"
    },
    ingress-3 = {
      rule_type   = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      src_or_dst  = "2.2.2.2/32"
      description = "test_dev"
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

variable "eks_cluster_sg_rule" {
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

variable "eks_node_group_sg_rule" {
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