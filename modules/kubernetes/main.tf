terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.17.0"
    }
  }
}


provider "kubernetes" {

  host                   = var.cluster_endpoint #cluster endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }

}



resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}
