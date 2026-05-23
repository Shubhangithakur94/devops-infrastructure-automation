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


variable "instances" {
  type = map(object({

    ami_id        = string
    instance_type = string
    associate_public_ip_address = bool
    key_name = optional(string)
    volume_size = number
    volume_type = string
    encrypted = bool
    delete_on_termination = bool
    subnet_key = string

  }))
}