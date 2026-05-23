variable "security_group_name" {
  type = string
}

variable "security_group_description" {
  type = string
}

variable "vpc_id" {
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

variable "tags" {
  type    = map(string)
  default = {}
}