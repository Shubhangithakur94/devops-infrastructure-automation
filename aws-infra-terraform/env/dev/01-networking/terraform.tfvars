################################
# LABELS
################################

aws_region = "ap-south-1"

project     = "sentinel"
environment = "dev"

tags = {
  Environment = "dev"
  Project     = "sentinel-server-assignment"
}

#################################
# VPC
#################################

vpcs = {

    networking = {

    vpc_cidr = "10.0.0.0/16"

    enable_dns_support   = true
    enable_dns_hostnames = true
  }
}

#################################
# SUBNETS
#################################

subnets = {

  public = {

    subnet_cidr       = "10.0.1.0/24"
    availability_zone = "ap-south-1a"

    vpc_key = "networking"

    public_subnet = true
  }

  private = {

    subnet_cidr       = "10.0.2.0/24"
    availability_zone = "ap-south-1a"
    
    vpc_key = "networking"
    public_subnet = false
  }
}

################################
# INTERNET GATEWAY
################################

igw_vpc_key = "networking"

#################################
# NAT GATEWAY
#################################

nat_gateway_subnet_key = "public"

#################################
# ROUTE TABLE
#################################

route_vpc_key = "networking"
private_subnet_key = "private"
public_subnet_key = "public"

#################################
# SECURITY GROUP
#################################

security_group_description = "Security group for private Sentry server"

#################################
# INGRESS RULES
#################################

ingress_rules = [

  {
    cidr_ipv4 = "10.0.2.0/24"

    from_port = 22
    to_port   = 22

    ip_protocol = "tcp"

    description = "Allow SSH"
  },
]

#################################
# EGRESS RULES
#################################

egress_rules = [

  {
    cidr_ipv4 = "0.0.0.0/0"

    from_port = -1
    to_port   = -1

    ip_protocol = "-1"

    description = "Allow all outbound traffic"
  }
]