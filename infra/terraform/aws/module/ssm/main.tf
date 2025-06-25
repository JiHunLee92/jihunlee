resource "aws_ssm_parameter" "this" {
  type  = "String"
  name  = var.ssm_name
  value = var.ssm_value
}