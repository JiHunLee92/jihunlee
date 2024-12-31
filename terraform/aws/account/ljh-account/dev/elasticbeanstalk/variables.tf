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
  default = "10.222.0.0/16"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "account_id" {
  default     = "11111111111"
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
      value     = "/"
    }
    SSLCertificateArns = {
      namespace = "aws:elbv2:listener:443"
      value     = "arn:aws:acm:ap-northeast-2:111111111:certificate/111111111"
    }
  }
}