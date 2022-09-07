variable "tags" {
  default = {
    "owner"     = "terraform-aws-terratest",
    "managedby" = "terratest",
    "project"   = "stackx",
    "workspace" = "terratest"
  }
}

variable "workspace_name" {
  default = "terratest"
}

variable "cluster_name" {
  default = "stackx"
}
