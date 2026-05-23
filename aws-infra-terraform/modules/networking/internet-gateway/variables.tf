variable "vpc_id" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}