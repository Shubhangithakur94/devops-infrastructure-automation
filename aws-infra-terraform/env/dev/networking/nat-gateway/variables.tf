variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "nat_gateway_name" {
  description = "NAT Gateway Name"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
  default     = {}
}