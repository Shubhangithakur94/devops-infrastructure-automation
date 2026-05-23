module "security_group" {
  source = "../../../../modules/security/security-group"

  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description

  vpc_id = var.vpc_id

  ingress_rules = var.ingress_rules

  egress_rules = var.egress_rules

  tags = var.tags
}