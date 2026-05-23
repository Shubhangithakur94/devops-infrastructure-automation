#################################
# LABELS
#################################

module "labels" {

  source = "../../../modules/labels"

  project     = var.project
  environment = var.environment
}

#################################
# VPC
#################################

module "vpc" {

  for_each = var.vpcs

  source = "../../../modules/networking/vpc"

  vpc_name = "${module.labels.prefix}-${each.key}-vpc"

  vpc_cidr = each.value.vpc_cidr

  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames

  tags = module.labels.common_tags
}

#################################
# SUBNETS
#################################

module "subnet" {

  for_each = var.subnets

  source = "../../../modules/networking/subnet"

  vpc_id = module.vpc[each.value.vpc_key].vpc_id

  subnet_name = "${module.labels.prefix}-${each.key}-subnet"

  subnet_cidr       = each.value.subnet_cidr
  availability_zone = each.value.availability_zone

  public_subnet = each.value.public_subnet

  tags = module.labels.common_tags
}

#################################
# INTERNET GATEWAY
#################################

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc[var.igw_vpc_key].vpc_id

  tags = merge(
    module.labels.common_tags,
    {
      Name = "${module.labels.prefix}-igw"
    }
  )
}

#################################
# NAT GATEWAY
#################################

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    module.labels.common_tags,
    {
      Name = "${module.labels.prefix}-eip"
    }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id

  subnet_id = module.subnet[var.nat_gateway_subnet_key].subnet_id

  tags = merge(
    module.labels.common_tags,
    {
      Name = "${module.labels.prefix}-nat-gateway"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

#################################
# PUBLIC ROUTE TABLE
#################################

module "public_route_table" {
  source = "../../../modules/networking/route-table"

  vpc_id = module.vpc[var.route_vpc_key].vpc_id

  subnet_id = module.subnet[var.public_subnet_key].subnet_id

  route_table_name = "${module.labels.prefix}-public-route-table"

  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  ]

  tags = module.labels.common_tags
}

#################################
# PRIVATE ROUTE TABLE
#################################

module "private_route_table" {
  source = "../../../modules/networking/route-table"

  vpc_id = module.vpc[var.route_vpc_key].vpc_id

  subnet_id = module.subnet[var.private_subnet_key].subnet_id

  route_table_name = "${module.labels.prefix}-private-route-table"

  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }
  ]

  tags = module.labels.common_tags
}

#################################
# SECURITY GROUP
#################################

module "security_group" {
  source = "../../../modules/networking/security-group"

  security_group_name        = "${module.labels.prefix}-security-group"
  security_group_description = var.security_group_description

  vpc_id = module.vpc[var.route_vpc_key].vpc_id

  ingress_rules = var.ingress_rules

  egress_rules = var.egress_rules

  tags = module.labels.common_tags
}