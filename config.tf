terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Set the AWS credentials profile and region you want to publish to.
provider "aws" {
  region  = var.region
  #profile = "mah"
}

terraform {
  required_version = ">= 0.15"

  backend "s3" {
    bucket = "terraform-state-mongulu" # should exists
    key = "mahoum/terraform.tfstate"
    region = "eu-central-1"
  }
}
