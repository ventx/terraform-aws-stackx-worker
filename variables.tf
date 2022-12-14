variable "name" {
  description = "Base Name for all resources (preferably generated by terraform-null-label)"
  type        = string
  default     = "stackx-worker"
}

variable "tags" {
  description = "User specific Tags to attach to resources (will be merged with module tags)"
  type        = map(string)
  default     = {}
}

variable "asg_tags" {
  description = "Add additional tags to the EKS Managed Node Group created AutoScalingGroup (in addition to the default cluster-autoscaler capacityType tag)"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to add to the EKS Worker nodes"
  type        = map(string)
  default = {
    "app" = "stackx"
  }
}

variable "taints" {
  description = "List of taints to add to the EKS Worker nodes (e.g. `{key = \"test\", value = \"example\", effect = \"NoSchedule\"}`)"
  type        = list(map(string))
  default     = [{}]
}

variable "static_unique_id" {
  description = "Static unique ID, defined in the root module once, to be suffixed to all resources for uniqueness (if you choose uuid, some resources will be cut of at max length - empty means NO / disable unique suffix)"
  type        = string
  default     = ""
}

variable "arch" {
  description = "CPU architecture to use for managed node groups (valid: `x86_64`, `ARM_64`)"
  type        = string
  default     = "x86_64"
  validation {
    condition     = contains(["x86_64", "ARM_64"], var.arch)
    error_message = "The selected CPU architecture is not valid - please choose one of: `x86_64`, `ARM_64`."
  }
}

variable "force_update_version" {
  description = "Force update of the version of the Managed Node Group even if PodDisruptionBudgets (PDB) are halting the drain process."
  type        = bool
  default     = false
}

variable "aws_key_name" {
  description = "Name of an existing AWS Key Pair name for SSH access to EKS Worker nodes - Leave empty to create new Key Pair"
  type        = string
  default     = ""
}

variable "ssh_security_group_ids" {
  description = "List of Security Group IDs to be allowed for SSH acess to EKS Worker nodes"
  type        = list(string)
  default     = []
}

variable "list_policies_arns" {
  description = "List of additional policy ARNs to attach to EKS Worker Instance Profile role (max. 10)"
  type        = list(string)
  validation {
    condition     = length(var.list_policies_arns) <= 10
    error_message = "Maximum allowed IAM Policy ARNs to attach: 10."
  }
  default = []
}

variable "instance_types" {
  description = "List of EC2 Instance types of AWS EKS - Managed Node Group for stateless applications (e.g. `[t3a.large]`)"
  type        = list(string)
  default     = ["c5a.2xlarge", "c6a.2xlarge"]
}

variable "desired_size" {
  description = "Number of desired AWS EKS Worker nodes - Managed Node Group. Will be IGNORED after initial deployment"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Maximum of AWS EKS Worker nodes - Managed Node Group Stateless (maximum capacity for ASG, e.g. `8`)"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum of AWS EKS Worker nodes - Managed Node Group Stateless (minimum capacity for ASG, e.g. `8`)"
  type        = number
  default     = 3
}

variable "disk_size" {
  description = "EBS disk size in GiB for AWS EKS Worker nodes."
  type        = number
  default     = 80
}

variable "tf_eks_node_group_timeouts" {
  description = "(Optional) Updated Terraform resource management timeouts. Applies to `aws_eks_node_group` in particular to permit resource management times"
  type        = map(string)
  default = {
    create = "40m"
    update = "60m"
    delete = "40m"
  }
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster version"
  type        = string
}

variable "release_version" {
  description = "EKS AMI release version (get from AWS SSM `/aws/service/eks/optimized-ami/1.20/amazon-linux-2/recommended`)"
  type        = string
  default     = null
}

variable "node_role_arn" {
  description = "IAM Role for workers"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs where to create workers into"
  type        = list(string)
}

variable "spot" {
  description = "Enable / Disable EC2 spot instances (`true` or `false`)"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID of EKS to create SecurityGroup for SSH access (optional)"
  type        = string
  default     = ""
}

variable "recovery_window_in_days" {
  description = "Secrets manager recovery window for SSH Public and Private Key for EKS Worker nodes"
  type        = number
  default     = 7
  validation {
    condition = (
      var.recovery_window_in_days >= 7 &&
      var.recovery_window_in_days <= 30
    )
    error_message = "Secrets manager recovery window needs to be between 7 and 30 days."
  }
}
