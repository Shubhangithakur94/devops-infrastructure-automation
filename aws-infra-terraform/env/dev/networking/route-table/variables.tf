variable "public_route_table_name" {
  description = "Public Route Table Name"
  type        = string
}

variable "private_route_table_name" {
  description = "Private Route Table Name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private Subnet ID"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
  default     = {}
}