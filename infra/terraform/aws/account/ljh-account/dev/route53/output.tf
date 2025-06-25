################################################################################
# Route53
################################################################################

output "route53_record_name" {
  description = "The name of the Route53 record"
  value       = module.test_dev_route53.route53_record
}

