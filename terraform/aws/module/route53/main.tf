################################################################################
# Route53
################################################################################

resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = "${var.domain_prefix}.${var.zone_name}"
  type    = var.record_type
  ttl     = "300"
  records = var.records
}

