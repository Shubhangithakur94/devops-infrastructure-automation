#################################
# LABELS
#################################

variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"

  default = {}
}

#################################
# VPC
#################################

variable "vpcs" {

  description = "VPC configurations"

  type = map(object({

    vpc_cidr = string

    enable_dns_support   = bool
    enable_dns_hostnames = bool

  }))
}

#################################
# SUBNETS
#################################

variable "subnets" {

  type = map(object({

    subnet_cidr       = string
    availability_zone = string
    vpc_key = string
    public_subnet = bool
  }))
}

#################################
# INTERNET GATEWAY
#################################

variable "igw_vpc_key" {
  type        = string
  description = "VPC key for Internet Gateway"
}

#################################
# NAT GATEWAY
#################################

variable "nat_gateway_subnet_key" {
  description = "Subnet key for NAT Gateway"
  type        = string
}

#################################
# ROUTE TABLE
#################################

variable "route_vpc_key" {
  description = "VPC key for Route Tables"
  type        = string
}

variable "private_subnet_key" {
  description = "Subnet key for Private Route Tables"
  type        = string
}

variable "public_subnet_key" {
  description = "Subnet key for Public Route Tables"
  type        = string
}

#################################
# SECURITY GROUP
#################################

variable "security_group_description" {
  type = string
}

#################################
# INGRESS RULES
#################################

variable "ingress_rules" {
  type = list(object({

    cidr_ipv4 = string

    from_port = number
    to_port   = number

    ip_protocol = string

    description = string
  }))
}

#################################
# EGRESS RULES
#################################

variable "egress_rules" {
  type = list(object({

    cidr_ipv4 = string

    from_port = number
    to_port   = number

    ip_protocol = string

    description = string
  }))
}