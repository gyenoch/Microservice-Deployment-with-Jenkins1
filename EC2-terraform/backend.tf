terraform {
  backend "s3" {
    bucket = "microservice-proj" # Replace with your actual S3 bucket name
    key    = "EC2/terraform.tfstate"
    region = "us-east-1"
  }
}