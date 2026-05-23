resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.nat_gateway_name}-eip"
    }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id

  subnet_id = var.public_subnet_id

  tags = merge(
    var.tags,
    {
      Name = var.nat_gateway_name
    }
  )

  depends_on = [var.internet_gateway_id]
}