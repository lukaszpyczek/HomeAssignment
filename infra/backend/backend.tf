terraform {
  backend "s3" {
    bucket         = "home-assignment-bucket"
    key            = "eks/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    entrypt        = true
  }
}
