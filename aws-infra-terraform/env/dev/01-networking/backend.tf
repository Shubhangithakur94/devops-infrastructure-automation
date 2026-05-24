terraform {
  backend "s3" {
    bucket         = "sentinel-dev-terraform-state-bkt"
    key            = "dev/networking/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}