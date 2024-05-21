###############################################################################
# CodeCommit
###############################################################################

module "test-dev-codecommit" {
  source = "../../../../module/codecommit"

  codecommit_name = "${var.name}-${var.environment}-codecommit"

  #   codecommit_approval_rule_template_name = var.test_codecommit_approval_rule_template_name
  #   codecommit_approval_rule_content = templatefile("./templates/codecommit_require_approved_approvers_rule.json", {
  #   })

  environment = var.environment

  tags = {
    Name = "${var.name}-${var.environment}-codecommit"
  }
}