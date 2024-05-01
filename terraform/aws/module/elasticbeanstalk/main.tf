################################################################################
# Elastic Beanstalk Environment
################################################################################

resource "aws_elastic_beanstalk_environment" "this" {
  name          = var.environment_name
  application   = var.application_name
  template_name = var.template_name

  tier         = "WebServer"
  cname_prefix = var.cname_prefix

  dynamic "setting" {
    for_each = merge(
      var.eb_default_settings,
      var.eb_settings,
      {
        VPCId = {
          namespace = "aws:ec2:vpc"
          value     = var.vpc_id
        }
        Subnets = {
          namespace = "aws:ec2:vpc"
          value     = join(",", sort(var.private_subnets_ids))

        }
        ELBSubnets = {
          namespace = "aws:ec2:vpc"
          value     = join(",", sort(var.public_subnets_ids))
        }
        SecurityGroups = {
          namespace = "aws:autoscaling:launchconfiguration"
          value     = var.aws_security_group
        }
        IamInstanceProfile = {
          namespace = "aws:autoscaling:launchconfiguration"
          value = var.iam_instance_profile
        }
      }
    )

    content {
      name      = setting.key
      namespace = setting.value["namespace"]
      value     = setting.value["value"]
    }
  }
}

