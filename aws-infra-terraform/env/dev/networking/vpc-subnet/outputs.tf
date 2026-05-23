output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.public_subnet.subnet_id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = module.private_subnet.subnet_id
}