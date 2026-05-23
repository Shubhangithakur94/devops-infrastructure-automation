resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes

    content {
      cidr_block     = route.value.cidr_block
      gateway_id     = try(route.value.gateway_id, null)
      nat_gateway_id = try(route.value.nat_gateway_id, null)
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.route_table_name
    }
  )
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.route_table.id
}