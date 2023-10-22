output "k8s_version" {
  description = "EKS Cluster K8s Version"
  value       = module.stackx-cluster.k8s_version
}

output "platform_version" {
  description = "EKS Cluster Platform Version"
  value       = module.stackx-cluster.platform_version
}

output "cluster_name" {
  description = "EKS Cluster name"
  value       = module.stackx-cluster.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = module.stackx-cluster.cluster_endpoint
}

output "oidc_issuer_arn" {
  description = "OIDC Identity issuer ARN for the EKS cluster (IRSA)"
  value       = module.stackx-cluster.oidc_issuer_arn
}

output "oidc_issuer" {
  description = "Issuer URL of EKS Cluster OIDC"
  value       = module.stackx-cluster.oidc_issuer
}

output "release_version" {
  description = "EKS Node Group release version"
  value       = module.stackx-worker.release_version
}
