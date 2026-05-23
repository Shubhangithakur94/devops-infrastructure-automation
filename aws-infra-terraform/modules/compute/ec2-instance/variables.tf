variable "instance_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type    = string
  default = null
}

variable "associate_public_ip_address" {
  type = bool
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "volume_size" {

  type    = number
  default = 20
}

variable "volume_type" {

  type    = string
  default = "gp3"
}

variable "encrypted" {
  type    = bool
  default = true
}

variable "delete_on_termination" {
  type    = bool
  default = true
}