terraform {
  backend "s3" {
    bucket         = "sentinel-dev-terraform-state-bucket"
    key            = "dev/networking/route-table/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}