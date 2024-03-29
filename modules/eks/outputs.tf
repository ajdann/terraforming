output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "Cluster certificate"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "Cluster Name"
  value       = module.eks.cluster_name
}


# output "config_map_aws_auth" {
#   description = "A kubernetes configuration to authenticate to this EKS cluster."
#   value       = module.eks.config_map_aws_auth
# }

