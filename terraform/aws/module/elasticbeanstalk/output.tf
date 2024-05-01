################################################################################
# Elastic Beanstalk Application
################################################################################

# output "elastic_beanstalk_application_name" {
#   description = "The name of the Elastic Beanstalk application"
#   value       = aws_elastic_beanstalk_application.this.name
# }

output "elastic_beanstalk_environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.name
}

output "elastic_beanstalk_environment_cname" {
  description = "The CNAME of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.cname
}

