variable "environment" {
  type        = string
  default     = "dev"
  description = "Variable used to tag resources"

}

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region to use"
}

variable "aws_version" {
  description = "Version of AWS provider"
  type        = string
  default     = "~> 4.0"

}

variable "terraform_version" {
  description = "Version of Terraform provider"
  type        = string
  default     = ">= 0.13.0"
}