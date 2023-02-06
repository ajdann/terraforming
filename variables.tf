variable "environment" {
  type    = string
  default = "dev"


}

variable "aws_version" {
    description = "Version of AWS provider"
    type = string
    default = "~> 4.0"
  
}

variable "terraform_version" {
  description = "Version of Terraform provider"
  type = string
  default = ">= 0.13.0"
}