################################################################################
# Elastic Beanstalk Application
################################################################################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.203.0.0/16"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "svc_test" {
  default = "test"
}

variable "account_id" {
  default = "711111111"
  description = "The account ID where the ECR repository is located"
}

variable "eb_settings" {
  default = {
    EC2KeyName = {
      namespace = "aws:autoscaling:launchconfiguration"
      value     = "test-dev-key"
    }
    InstanceTypes = {
      namespace = "aws:ec2:instances"
      value     = "c6i.large"
    }
    HealthCheckPath = {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      # value     = "/api/health_check"
      value     = "/"
    }
    SSLCertificateArns = {
      namespace = "aws:elbv2:listener:443"
      value     = "arn:aws:acm:ap-northeast-2:71111111:certificate/c11111111111"
    }
  }
}
