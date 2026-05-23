variable "instances" {
  type = map(object({

    ami_id        = string
    instance_type = string

    subnet_id = string

    security_group_ids = list(string)

    associate_public_ip_address = bool

    key_name = optional(string)

    volume_size = number

    volume_type = string

    encrypted = bool

    delete_on_termination = bool

  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}