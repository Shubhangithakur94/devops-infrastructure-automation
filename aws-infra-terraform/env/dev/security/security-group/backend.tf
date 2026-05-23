terraform {
  backend "s3" {
    bucket         = "sentinel-dev-terraform-state-bucket"
    key            = "dev/security/security-group/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}