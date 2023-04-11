provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "sherpany-tf-state"
    dynamodb_table = "sherpany-tf-state-lock"
    encrypt        = "true"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
  }
}
