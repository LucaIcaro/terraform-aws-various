provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      env = "test"
    }
  }
}

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
