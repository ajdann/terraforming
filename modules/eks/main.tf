terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name                 = "k8s vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/var.cluster_name" = "shared"
    "kubernetes.io/role/elb"                 = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/var.cluster_name" = "shared"
    "kubernetes.io/role/internal-elb"        = "1"
  }
  tags = {
    environment = var.environment
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.7.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = "1.24"
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id                          = module.vpc.vpc_id #vpc to use
  cluster_timeouts = {
    "create" = "1h"
  }
  cluster_tags = {
    environment = var.environment
  }

  eks_managed_node_groups = {
    spot = {
      desired_state = 1
      min_size      = 1
      max_size      = 2

      labels = {
        environment = var.environment

      }
      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }

  }

}

module "iam_iam-policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.11.1"

  name = "allow-eks-access"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

# module "iam_iam-assumable-role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.11.1"

#   role_name = "eks-admin"
#   create_role = true
#   role_requires_mfa = false
#   custom_role_policy_arns = [module.alloweks_access_iam_policy.arn]

#   trusted_role_arns = [
#     "arn:aws:iam::${module.vpc.vpc_owner_id}:root"
#   ]
# }




# module "iam_iam-user" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-user"
#   version = "5.11.1"
#   # insert the 1 required variable here
#   name = "ajdin"
#   create_iam_access_key = false
#   create_iam_user_login_profile = false

#   force_destroy = true
# }



# module "allow_assume_eks_admins_iam_policy" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "5.11.1"

#   name = "allow-assume-eks-admin-iam-role"
#   create_policy = true

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#         ]
#         Effect = "Allow"
#         Resource = module.eks_admins_iam_role.iam_role_arn
#       }
#     ]
#   })
# }


# #create an IAM group with the policy
# module "iam_example_iam-group-with-policies" {
#   source  = "terraform-aws-modules/iam/aws//examples/iam-group-with-policies"
#   version = "5.11.1"

#   name = "eks-admin"
#   attach_iam_self_management_policy = false
#   create_group = true
#   group_users = [module.iam_iam-user.iam_user_name]
#   custom_group_policy_arns = [module.allow_assume_eks_admins_iam_policy.arn]
# }