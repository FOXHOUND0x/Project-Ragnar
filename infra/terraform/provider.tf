terraform {
  backend "s3" {
    bucket = "the0x"
    key = "services/raganar-cli/infra"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.69.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.0.0-alpha1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}