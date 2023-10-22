# --------------------------------------------------------------------------
# Worker - IAM role & Instance Profile
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "tr" {
  count = var.node_role_arn == null ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "eks_worker" {
  count = var.node_role_arn == null ? 1 : 0

  // expected length of name to be in the range (1 - 64)
  name                  = substr(lower("${var.cluster_name}-eks-worker-${var.name}-${random_string.random_name.result}"), 0, 63)
  assume_role_policy    = data.aws_iam_policy_document.tr.0.json
  force_detach_policies = true

  tags = local.tags
}

resource "aws_iam_instance_profile" "eks_worker" {
  count = var.node_role_arn == null ? 1 : 0

  # https://docs.aws.amazon.com/IAM/latest/APIReference/API_InstanceProfile.html
  # Minimum length of 1.
  # Maximum length of 128.
  name = substr(lower("${var.cluster_name}-eks-worker-${var.name}-${random_string.random_name.result}"), 0, 127)
  role = aws_iam_role.eks_worker.0.name

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each = toset(flatten([
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
    var.list_policies_arns,
  ]))
  policy_arn = each.key
  role       = var.node_role_arn == null ? aws_iam_role.eks_worker.0.name : var.node_role_arn
}
