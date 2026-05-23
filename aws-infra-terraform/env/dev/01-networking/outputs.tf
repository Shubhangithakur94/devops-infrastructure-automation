output "vpc_ids" {

  description = "VPC IDs"

  value = {
    for k, v in module.vpc : k => v.vpc_id
  }
}

output "subnet_ids" {

  description = "Subnet IDs"

  value = {
    for k, v in module.subnet : k => v.subnet_id
  }
}

output "security_group_id" {
  value = module.security_group.security_group_id
}