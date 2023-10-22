# Get the current AWS partition (aws, aws-cn, aws-us-gov)
data "aws_partition" "current" {}

# Get EKS Node Group AMI release version
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/bottlerocket/aws-k8s-${var.cluster_version}${var.gpu_ami ? "-nvidia" : ""}/${var.arch == "x86_64" ? var.arch : "arm64"}/latest/image_version"
}
