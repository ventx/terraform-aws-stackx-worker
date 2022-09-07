module "stackx-worker" {
  source = "../"

  cluster_name     = module.stackx-cluster.cluster_name
  cluster_version  = module.stackx-cluster.cluster_version
  static_unique_id = "f2f6c971-6a3c-4d6e-9dca-7a3ba454d64d" # just random uuid generated for testing cut offs etc
  instance_types   = ["t3a.2xlarge", "c5a.2xlarge", "c6a.2xlarge"]

  disk_size  = 30
  subnet_ids = module.stackx-network.private_subnet_ids
  vpc_id     = module.stackx-cluster.vpc_id

  labels = {
    "app"  = "stackx"
    "test" = "terratest"
  }
  tags = {
    examples = "example"
  }
}

module "stackx-cluster" {
  source  = "ventx/stackx-cluster/aws"
  version = "0.1.0"

  cluster_version  = "1.23"
  static_unique_id = "f2f6c971-6a3c-4d6e-9dca-7a3ba454d64d" # just random uuid generated for testing cut offs etc
  subnet_ids       = module.stackx-network.private_subnet_ids

  tags = {
    examples = "example"
  }
}

module "stackx-network" {
  source  = "ventx/stackx-network/aws"
  version = "0.1.0"

  name           = "stackx-0-network"
  workspace_name = var.workspace_name
  cluster_name   = var.cluster_name
  tags = {
    test     = true,
    deleteme = true
  }

  # VPC
  single_nat_gateway = true

  # Private Subnets
  private = true
  private_subnet_tags = merge(
    var.tags,
    {
      "Access" = "private"
    }
  )

  # Public Subnets
  public = true
  public_subnet_tags = merge(
    var.tags,
    {
      "Access" = "public"
    }
  )
}
