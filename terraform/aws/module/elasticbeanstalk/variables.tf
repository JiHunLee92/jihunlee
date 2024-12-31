################################################################################
# Elastic Beanstalk Application
################################################################################

variable "application_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
}

variable "environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  type        = string
}

variable "template_name" {
  description = "The name of the Elastic Beanstalk configuration template"
  type        = string
}

variable "cname_prefix" {
  description = "The CNAME prefix to use for the Elastic Beanstalk environment"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to use for the Elastic Beanstalk environment"
  type        = string
}

variable "private_subnets_ids" {
  description = "A list of IDs of the private subnets to use for the Elastic Beanstalk environment"
  type        = list(string)
}

variable "public_subnets_ids" {
  description = "A list of IDs of the public subnets to use for the Elastic Beanstalk environment"
  type        = list(string)
}

variable "aws_security_group" {
  description = "The ID of the security group to use for the Elastic Beanstalk environment"
  type        = string
}

variable "iam_instance_profile" {
  description = "The ARN of the IAM instance profile to use for the Elastic Beanstalk environment"
  type        = string
}

variable "eb_settings" {
  description = "A map of default settings to apply to the Elastic Beanstalk application"
  type        = map(map(string))
}

variable "eb_default_settings" {
  description = "A map of default settings to apply to the Elastic Beanstalk application"
  type        = map(map(string))
  default = {
    EC2KeyName = {
      namespace = "aws:autoscaling:launchconfiguration"
      value     = "test-dev-key"
    }
    InstanceTypes = {
      namespace = "aws:ec2:instances"
      value     = "t3.small"
    }
    RootVolumeType = {
      namespace = "aws:autoscaling:launchconfiguration"
      value     = "gp3"
    }
    RootVolumeSize = {
      namespace = "aws:autoscaling:launchconfiguration"
      value     = "10"
    }
    AssociatePublicIpAddress = {
      namespace = "aws:ec2:vpc"
      value     = "false"
    }
    MinSize = {
      namespace = "aws:autoscaling:asg"
      value     = "1"
    }
    MaxSize = {
      namespace = "aws:autoscaling:asg"
      value     = "2"
    }
    DisableIMDSv1 = {
      namespace = "aws:autoscaling:launchconfiguration"
      value     = "true"
    }
    LoadBalancerType = {
      namespace = "aws:elasticbeanstalk:environment"
      value     = "application"
    }
    StreamLogs = {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      value     = "true"
    }
    ListenerEnabled = {
      namespace = "aws:elbv2:listener:default"
      value     = "true"
    }
    ListenerEnabled = {
      namespace = "aws:elbv2:listener:443"
      value     = "true"
    }
    DefaultProcess = {
      namespace = "aws:elbv2:listener:443"
      value     = "default"
    }
    Protocol = {
      namespace = "aws:elbv2:listener:443"
      value     = "HTTPS"
    }
    MatcherHTTPCode = {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      value     = "200"
    }
    SystemType = {
      namespace = "aws:elasticbeanstalk:healthreporting:system"
      value     = "enhanced"
    }
    # LogPublicationControl = {
    #   namespace = "aws:elasticbeanstalk:hostmanager"
    #   value = "false"
    # } 
    # DeploymentPolicy = {
    #   namespace = "aws:elasticbeanstalk:command"
    #   value = "Rolling"
    # } 
    # MinInstancesInService = {
    #   namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    #   value = "0"
    # } 
    # RollingUpdateType = {
    #   namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    #   value = "Health"
    # }
    # MaxBatchSize = {
    #   namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    #   value = "1"
    # } 
    # ServiceRole = {
    #   namespace = "aws:elasticbeanstalk:environment"
    #   value = "arn:aws:iam::1111111111:role/aws-elasticbeanstalk-service-role"
    # } 
    # LoadBalancerIsShared = {
    #   namespace = "aws:elasticbeanstalk:environment"
    #   value = "true"
    # }
  }
}
