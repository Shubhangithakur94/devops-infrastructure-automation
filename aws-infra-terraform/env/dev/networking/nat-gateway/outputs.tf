output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gateway.id
}

output "elastic_ip" {
  description = "Elastic IP of NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}