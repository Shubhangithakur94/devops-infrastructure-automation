variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnet_name" {
  description = "Public Subnet Name"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
}

variable "private_subnet_name" {
  description = "Private Subnet Name"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
  default     = {}
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
}

variable "public_subnet" {
  description = "Public subnet"
  type        = bool
}

variable "private_subnet" {
  description = "Private subnet"
  type        = bool
}