output "node_group_arn" {
  value = aws_eks_node_group.worker.arn
}

output "node_group_asg_name" {
  value = aws_eks_node_group.worker.resources.0.autoscaling_groups.0.name
}

output "node_group_ssh_security_group_id" {
  value = aws_eks_node_group.worker.resources.0.remote_access_security_group_id
}

output "cluster_name" {
  value = aws_eks_node_group.worker.cluster_name
}

output "node_group_role_arn" {
  description = "EKS Worker Managed Node Group IAM Role ARN"
  value       = var.node_role_arn == null ? aws_iam_role.eks_worker.0.arn : var.node_role_arn
}

output "node_group_subnet_ids" {
  description = "EKS Worker Managed Node Group Subnet IDs"
  value       = aws_eks_node_group.worker.subnet_ids
}

output "node_group_role_name" {
  description = "EKS Worker Managed Node Group IAM Role Name"
  # Get the second match [1] in regex from role ARN variable which is the role-name (first one [0] would be the AWS Account ID)
  value = var.node_role_arn == null ? aws_iam_role.eks_worker.0.name : regex("arn:aws:iam::[0-9]+:role/(.+)", var.node_role_arn)[1]
}

output "release_version" {
  description = "EKS Managed Node Group release version"
  value       = aws_eks_node_group.worker.release_version
}

output "release_version_latest" {
  description = "Latest available AMI release version"
  value       = data.aws_ssm_parameter.eks_ami_release_version.value
}

