data "aws_route53_zone" "test_com" {
  name         = "test.com."
  private_zone = false
}