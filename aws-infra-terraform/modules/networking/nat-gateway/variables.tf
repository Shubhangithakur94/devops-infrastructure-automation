variable "public_subnet_id" {
  type = string
}

variable "internet_gateway_id" {
  type = string
}

variable "nat_gateway_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}