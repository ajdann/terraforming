provider "aws" {
  region = var.region
}

# module "vpc" {
#   source = "./modules/vpc"

#   # define variables for module
#   environment = var.environment
# }

# module "backend_state" {
#   source = "./modules/remote_backend"
#   # define variables for module
#   environment = var.environment
# }

module "eks" {
  source = "./modules/eks"

  environment  = var.environment
  region       = var.region
  cluster_name = "acheEKS"


}

module "helm-argocd" {
  source                             = "./modules/helm"
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  cluster_name                       = module.eks.cluster_name

}

module "kubernetes" {
  source                             = "./modules/kubernetes"
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  cluster_name                       = module.eks.cluster_name
}
