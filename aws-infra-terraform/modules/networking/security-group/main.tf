resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = var.security_group_description

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = var.security_group_name
    }
  )
}

#################################
# INGRESS RULES
#################################

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each = {
    for idx, rule in var.ingress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.security_group.id

  cidr_ipv4 = each.value.cidr_ipv4

  from_port = each.value.from_port
  to_port   = each.value.to_port

  ip_protocol = each.value.ip_protocol

  description = each.value.description
}

#################################
# EGRESS RULES
#################################

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each = {
    for idx, rule in var.egress_rules :
    idx => rule
  }

  security_group_id = aws_security_group.security_group.id

  cidr_ipv4 = each.value.cidr_ipv4

  from_port = each.value.from_port
  to_port   = each.value.to_port

  ip_protocol = each.value.ip_protocol

  description = each.value.description
}