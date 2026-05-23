terraform {
  backend "s3" {
    bucket         = "sentinel-dev-terraform-state-bucket"
    key            = "dev/networking/vpc-subnet/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}