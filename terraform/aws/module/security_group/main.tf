################################################################################
# Security group 
# Link : https://github.com/terraform-aws-modules/terraform-aws-security-group
################################################################################

resource "aws_security_group" "this" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  tags = merge(
    {
      Terraform   = var.terraform
      Environment = var.environment
    },
    var.tags
  )
}

################################################################################
# Security Group Rule
################################################################################

resource "aws_security_group_rule" "sg_rule" {
  for_each = var.sg_rule

  security_group_id = aws_security_group.this.id

  type                     = each.value.rule_type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = length(regexall("[a-z]", each.value.src_or_dst)) == 0 ? [each.value.src_or_dst] : null
  source_security_group_id = each.value.src_or_dst == "self" ? null : length(regexall("[a-z]", each.value.src_or_dst)) != 0 ? each.value.src_or_dst : null
  self                     = each.value.src_or_dst == "self" ? true : null
}