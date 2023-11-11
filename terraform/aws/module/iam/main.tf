################################################################################
# IAM 
################################################################################

resource "aws_iam_role" "this" {

  assume_role_policy = var.assume_role_policy
  name               = var.role_name

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.aws_iam_role_policy_attachment

  role       = aws_iam_role.this.name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "this" {
  for_each = var.aws_iam_role_policy

  role   = aws_iam_role.this.name
  name   = each.value.role_policy_name
  policy = each.value.role_policy
}

################################################################################
# IAM Policy
################################################################################

# resource "aws_iam_policy" "policy" {

#   name   = var.policy_name
#   policy = var.policy

#   tags = merge(
#     {
#       Terraform   = var.terraform
#       Environment = var.environment
#     },
#     var.tags
#   )
# }