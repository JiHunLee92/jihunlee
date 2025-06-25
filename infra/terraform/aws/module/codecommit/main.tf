###############################################################################
# CodeCommit
###############################################################################

resource "aws_codecommit_repository" "this" {
  repository_name = var.codecommit_name

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )
}

# resource "aws_codecommit_approval_rule_template" "this" {
#   name    = var.codecommit_approval_rule_template_name
#   content = var.codecommit_approval_rule_content
# }

# resource "aws_codecommit_approval_rule_template_association" "this" {
#   approval_rule_template_name = aws_codecommit_approval_rule_template.this.name
#   repository_name             = aws_codecommit_repository.this.repository_name
# }