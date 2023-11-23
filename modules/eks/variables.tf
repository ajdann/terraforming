variable "region" {
  type = string
}
variable "environment" {
  type = string
}
variable "cluster_name" {
  type        = string
  description = "Name for the kubernetes cluster"
}


variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap"
  type        = list(string)

  default = ["test"]

}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [{
    groups   = ["value"]
    rolearn  = "value"
    username = "value"
  }]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap"
  type = list(object({
    useranr  = string
    username = string
    groups   = list(string)

  }))
  default = [
  ]
}

