module "stackx-worker" {
  source = "../"

  cluster_name    = module.stackx-cluster.cluster_name
  cluster_version = module.stackx-cluster.cluster_version
  instance_types  = ["t3a.xlarge"]

  disk_size  = 20
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
  version = "0.3.1"

  cluster_version = "1.27"
  subnet_ids      = module.stackx-network.private_subnet_ids

  tags = {
    examples = "example"
  }
}

module "stackx-network" {
  source  = "ventx/stackx-network/aws"
  version = "0.2.3"

  name         = "stackx-0-network"
  cluster_name = var.cluster_name
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
