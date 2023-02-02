terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
    version = ">= 2.28.1"
    region = var.region
}

data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {

}


resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id = module.vpc.vpc_id # output of module.vpc

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
  
    cidr_blocks = [
        "10.0.0.0/8",
        "178.77.2.49/32"
    ]
  }
}