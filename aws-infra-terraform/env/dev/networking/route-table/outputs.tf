output "public_route_table_id" {
  description = "Public Route Table ID"

  value = module.public_route_table.route_table_id
}

output "private_route_table_id" {
  description = "Private Route Table ID"

  value = module.private_route_table.route_table_id
}