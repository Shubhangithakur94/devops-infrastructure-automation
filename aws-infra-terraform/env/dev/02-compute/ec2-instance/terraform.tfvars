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
## EC2 Instances
#################################

instances = {

  sentry-server = {

    ami_id        = "ami-07a00cf47dbbc844c"
    instance_type = "r5.xlarge"
    associate_public_ip_address = false
    key_name = "sentry-key"
    volume_size = 32
    volume_type = "gp3"
    encrypted = true
    delete_on_termination = true
    subnet_key = "private"
  }
  
  ansible-server = {

    ami_id        = "ami-07a00cf47dbbc844c"
    instance_type = "t3.micro"
    associate_public_ip_address = false
    key_name = "sentry-key"
    volume_size = 8
    volume_type = "gp3"
    encrypted = false
    delete_on_termination = true
    subnet_key = "private"
  }
}