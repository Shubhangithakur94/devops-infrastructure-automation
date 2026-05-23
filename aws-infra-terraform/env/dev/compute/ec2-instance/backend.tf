terraform {
  backend "s3" {
    bucket         = "sentinel-dev-terraform-state-bucket"
    key            = "dev/compute/ec2-instance/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}