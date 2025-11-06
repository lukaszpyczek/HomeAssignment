terraform {
  required_version = "~> 1.12"

  backend "s3" {
    bucket       = "home-assignment-terraform-state"
    key          = "eks/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.25.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
  }
}
provider "aws" {
  region = var.region
}
