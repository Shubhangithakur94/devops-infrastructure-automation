#################################
# VPC
#################################

module "vpc" {
  source = "../../../../modules/networking/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = var.tags
}

#################################
# PUBLIC SUBNET
#################################

module "public_subnet" {
  source = "../../../../modules/networking/subnet"

  vpc_id = module.vpc.vpc_id

  subnet_name       = var.public_subnet_name
  subnet_cidr       = var.public_subnet_cidr
  availability_zone = var.availability_zone

  public_subnet = var.public_subnet

  tags = var.tags
}

#################################
# PRIVATE SUBNET
#################################

module "private_subnet" {
  source = "../../../../modules/networking/subnet"

  vpc_id = module.vpc.vpc_id

  subnet_name       = var.private_subnet_name
  subnet_cidr       = var.private_subnet_cidr
  availability_zone = var.availability_zone

  public_subnet = var.private_subnet

  tags = var.tags
}