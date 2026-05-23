variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "route_table_name" {
  type = string
}

variable "routes" {
  type = list(object({
    cidr_block = string
    gateway_id = optional(string)
    nat_gateway_id = optional(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}