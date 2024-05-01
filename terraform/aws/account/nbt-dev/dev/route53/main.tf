################################################################################
# Route53
################################################################################

module "test_dev_route53" {
  source = "../../../../module/route53/"
  
  zone_id = data.aws_route53_zone.test.zone_id
  zone_name = data.aws_route53_zone.test.name

  domain_prefix = "${var.svc_test}-${var.environment}-${var.test_dev_domain_prefix}"
  record_type   = var.test_dev_api_record_type
  records       = [data.terraform_remote_state.elasticbeanstalk.outputs.test_api_cname]
}

