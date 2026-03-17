terraform {
  backend "s3" {
    bucket         = "terraform-state-769979514514"
    key            = "staging/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}