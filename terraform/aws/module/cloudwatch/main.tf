##################################################################
# CloudWatch Log Group
# Link : https://github.com/terraform-aws-modules/terraform-aws-cloudwatch
##################################################################

resource "aws_cloudwatch_log_group" "this" {
  count = 1

  name              = var.cloudwatch_log_group_name
  retention_in_days = var.retention_in_days

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )
}