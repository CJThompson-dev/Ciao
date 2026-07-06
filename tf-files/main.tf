terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "cia-tf-backend"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}