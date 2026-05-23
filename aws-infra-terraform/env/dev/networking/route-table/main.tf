#################################
# PUBLIC ROUTE TABLE
#################################

module "public_route_table" {
  source = "../../../../modules/networking/route-table"

  vpc_id = var.vpc_id

  subnet_id = var.public_subnet_id

  route_table_name = var.public_route_table_name

  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.internet_gateway_id
    }
  ]

  tags = var.tags
}

#################################
# PRIVATE ROUTE TABLE
#################################

module "private_route_table" {
  source = "../../../../modules/networking/route-table"

  vpc_id = var.vpc_id

  subnet_id = var.private_subnet_id

  route_table_name = var.private_route_table_name

  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_id
    }
  ]

  tags = var.tags
}