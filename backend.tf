terraform {
  backend "s3" {
    bucket = "my-tfstatebucket"
    key    = "./terraform.tfstate"
    region = "us-east-1"
  }
}