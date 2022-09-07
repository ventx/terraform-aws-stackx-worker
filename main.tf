locals {
  asg_tags = merge(
    var.tags,
    var.asg_tags,
    {
      "k8s.io/cluster-autoscaler/node-template/label/eks.amazonaws.com/capacityType" : var.spot ? "SPOT" : "ON_DEMAND",
    }
  )
  tags = merge(
    var.tags,
    {
      "Module" = "terraform-aws-stackx-worker"
      "Github" = "https://github.com/ventx/terraform-aws-stackx-worker"
    }
  )
}


# --------------------------------------------------------------------------
# Generate 4 character random name for Managed Node Groups
# This will be used when changing parameters which require
# the Node Group to be recreated (see `create_before_destroy`)
# --------------------------------------------------------------------------
resource "random_string" "random_name" {
  length  = 4
  upper   = false
  numeric = false
  lower   = true
  special = false
}


# --------------------------------------------------------------------------
# EKS Managed NodeGroup - Bottlerocket
# --------------------------------------------------------------------------
resource "aws_eks_node_group" "worker" {
  # max 63 characters
  node_group_name = substr(lower("${var.name}-${random_string.random_name.result}"), 0, 62)

  ami_type             = "BOTTLEROCKET_${var.arch}"
  capacity_type        = var.spot ? "SPOT" : "ON_DEMAND"
  cluster_name         = var.cluster_name
  force_update_version = var.force_update_version
  instance_types       = flatten([var.instance_types])
  node_role_arn        = var.node_role_arn == null ? aws_iam_role.eks_worker.0.arn : var.node_role_arn
  subnet_ids           = var.subnet_ids
  release_version      = var.release_version
  version              = var.cluster_version

  labels = {
    "apps" = var.name,
  }

  disk_size = var.disk_size


  update_config {
    max_unavailable            = 1
    max_unavailable_percentage = null
  }

  remote_access {
    ec2_ssh_key               = var.aws_key_name != "" ? var.aws_key_name : aws_key_pair.ssh.0.key_name
    source_security_group_ids = flatten([length(var.ssh_security_group_ids) != 0 ? var.ssh_security_group_ids : [aws_security_group.ssh.0.id]])
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags_all = local.tags

  timeouts {
    create = lookup(var.tf_eks_node_group_timeouts, "create", null)
    delete = lookup(var.tf_eks_node_group_timeouts, "delete", null)
    update = lookup(var.tf_eks_node_group_timeouts, "update", null)
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# --------------------------------------------------------------------------
# Add tags to the EKS Managed Node Group created AutoScalingGroup
# --------------------------------------------------------------------------
resource "aws_autoscaling_group_tag" "stateless" {
  for_each = { for k, v in merge(local.tags, local.asg_tags) : k => v }

  autoscaling_group_name = aws_eks_node_group.worker.resources.0.autoscaling_groups.0.name

  tag {
    key   = each.key
    value = each.value

    propagate_at_launch = true
  }
}
