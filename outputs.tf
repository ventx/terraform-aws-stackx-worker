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
