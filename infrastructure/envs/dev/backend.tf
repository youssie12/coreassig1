terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket  = "coreassig1-terraform-state-bucket"
    key     = "terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}