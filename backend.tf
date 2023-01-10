terraform {
  backend "s3" {
    bucket         = "sampletestdevbuckettfstate"
    key            = "dev/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "eu-central-1"
  }
}