provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "./modules/vpc"

  # define variables for module
  environment = var.environment
}

module "backend_state" {
  source = "./modules/remote_backend"
  # define variables for module
  environment = var.environment
}