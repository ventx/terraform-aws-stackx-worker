variable "cluster_name" {
  description = "Cluster name to use for tests"
  type        = string
  default     = "stackx-test"
}

variable "tags" {
  type = map(string)
  default = {
    "repo"     = "terraform-aws-stackx-worker"
    "test"     = "true",
    "deleteme" = "true"
  }
}
