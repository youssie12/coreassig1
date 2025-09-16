terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = "coreassig1-terraform-state-bucket"
    key            = "myproject/prod/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}
