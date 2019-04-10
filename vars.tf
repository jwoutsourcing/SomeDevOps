provider "aws" {
  shared_credentials_file = "/app/.aws/credentials"
}

terraform {
  backend "s3" {
    shared_credentials_file = "/app/.aws/credentials"
    bucket                  = "steve-wood-tfstate"
    key                     = "terraform/tfstate"
    region                  = "us-east-1"
  }
}

variable "provider" {
  type = "map"

  default = {
    region = "us-east-1"
  }
}

variable "azs" {
  type = "map"

  default = {
    "us-east-1" = "us-east-1a,us-east-1b,us-east-1c"
  }
}

variable vpc {
  type = "map"

  default = {
    cidr_block  = "10.99.0.0/20"
    subnet_bits = "4"
  }
}

variable ami {
  default = "ami-fbacaaec"
}
