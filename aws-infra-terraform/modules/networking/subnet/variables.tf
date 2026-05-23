variable "vpc_id" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "public_subnet" {
  type = bool
}

variable "tags" {
  type    = map(string)
  default = {}
}