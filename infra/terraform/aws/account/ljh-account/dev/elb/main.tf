##################################################################
# Elastic Load Balancer
##################################################################

module "test_admin_alb" {
  source = "../../../../module/elb"

  lb_name = "${var.name}-${var.environment}-admin-alb"

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  load_balancer_type = var.load_balancer_type_alb
  internal           = var.internal_f
  security_groups    = [data.terraform_remote_state.sg.outputs.admin_alb_sg]
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnets
  idle_timeout       = var.idle_timeout_60

  access_logs = {}

  target_groups = [
    {
      name                          = "admin-target-group"
      backend_port                  = 80
      backend_protocol              = "HTTP"
      protocol_version              = "HTTP1"
      target_type                   = "ip"
      load_balancing_algorithm_type = "round_robin"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = 443
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.test-com.arn
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed message"
        status_code  = "403"
      }
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0

      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]

      conditions = [{
        host_headers = ["test.com"]
      }]
    }
  ]

  environment = var.environment

  # target_group_attachments = {
  #   admin = {
  #     target_group_arn  = module.test_admin_alb.target_groups
  #     target_id         = data.terraform_remote_state.ec2.outputs.gateway_ec2_id
  #     port              = 80
  #     availability_zone = "ap-northeast-2a"
  #   }
  # }

  elb_tags = {
    Name = "${var.name}-${var.environment}-admin-alb"
  }
}

##################################################################
# TEST
##################################################################


# module "test_admin_alb" {
#   source = "../../../../module/elb"

#   name = "${var.name}-${var.environment}-admin-alb"

#   load_balancer_type = var.load_balancer_type_alb
#   internal           = var.internal_t
#   security_groups    = [data.terraform_remote_state.sg.outputs.admin_alb_sg]
#   subnets            = data.terraform_remote_state.vpc.outputs.public_subnets
#   idle_timeout       = var.idle_timeout_60
#   #   enable_cross_zone_load_balancing = var.admin_alb_enable_cross_zone_load_balancing

#   access_logs = {
#     # "logs" = {
#     # enabled = true
#     # bucket  = data.aws_s3_bucket.nlp-test-log.bucket_domain_name
#     # }
#   }

#   target_groups = [
#     {
#       name                          = "admin-target-group"
#       backend_port                  = 80
#       backend_protocol              = "HTTP"
#       protocol_version              = "HTTP1"
#       target_type                   = "ip"
#       load_balancing_algorithm_type = "round_robin"
#       health_check = {
#         enabled             = true
#         interval            = 30
#         path                = "/"
#         port                = "traffic-port"
#         healthy_threshold   = 3
#         unhealthy_threshold = 3
#         timeout             = 6
#         protocol            = "HTTP"
#         matcher             = "200-399"
#       }
#       stickiness = {
#         enabled = true
#         type    = "lb_cookie"
#       }
#     },
#     {
#       name                          = "logic-target-group"
#       backend_port                  = 80
#       backend_protocol              = "HTTP"
#       protocol_version              = "HTTP1"
#       target_type                   = "ip"
#       load_balancing_algorithm_type = "round_robin"
#       health_check = {
#         enabled             = true
#         interval            = 30
#         path                = "/"
#         port                = "traffic-port"
#         healthy_threshold   = 3
#         unhealthy_threshold = 3
#         timeout             = 6
#         protocol            = "HTTP"
#         matcher             = "200-399"
#       }
#       stickiness = {
#         enabled = true
#         type    = "lb_cookie"
#       }
#     }
#   ]

#   http_tcp_listeners = [
#     {
#       port        = 80
#       protocol    = "HTTP"
#       action_type = "redirect"
#       redirect = {
#         port        = 443
#         protocol    = "HTTPS"
#         status_code = "HTTP_301"
#       }
#     }
#   ]

#   https_listeners = [
#     {
#       port            = 443
#       protocol        = "HTTPS"
#       certificate_arn = null
#       ssl_policy      = null
#       action_type     = "fixed-response"
#       fixed_response = {
#         content_type = "text/plain"
#         message_body = "Fixed message"
#         status_code  = "403"
#       }
#     }
#   ]

#   http_tcp_listener_rules = [
#     {
#       http_tcp_listener_index = 0
#       priority                = 3
#       actions = [{
#         type         = "fixed-response"
#         content_type = "text/plain"
#         status_code  = 200
#         message_body = "This is a fixed response"
#       }]

#       conditions = [{
#         http_headers = [{
#           http_header_name = "x-Gimme-Fixed-Response"
#           values           = ["yes", "please", "right now"]
#         }]
#       }]
#     }
#   ] 

#   environment = var.environment

#   elb_tags = {
#     Name = "${var.name}-${var.environment}-admin-alb"
#   }
# }