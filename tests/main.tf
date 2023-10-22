module "worker" {
  source = "../"

  cluster_name    = module.cluster.cluster_name
  cluster_version = module.cluster.cluster_version
  subnet_ids      = module.network.private_subnet_ids
  instance_types  = ["t3a.large", "t3a.large"]
  desired_size    = 2
  max_size        = 2
  min_size        = 2
  disk_size       = 20
  spot            = true
  vpc_id          = module.network.vpc_id

  tags = var.tags
}

module "cluster" {
  source  = "ventx/stackx-cluster/aws"
  version = "0.3.1"

  name            = var.cluster_name
  cluster_version = "1.27"
  subnet_ids      = module.network.private_subnet_ids

  tags = var.tags
}

module "network" {
  source  = "ventx/stackx-network/aws"
  version = "0.2.3"

  name         = "test-all-0-network"
  cluster_name = var.cluster_name
  tags         = var.tags

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
