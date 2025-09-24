terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  region                = var.aws_region
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  app_subnet_cidr       = "10.0.2.0/24"
  monitoring_subnet_cidr= "10.0.3.0/24"
  data_subnet_cidr      = "10.0.4.0/24"
}
