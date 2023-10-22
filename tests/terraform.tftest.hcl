provider "aws" {
  region = "us-east-1"
}

run "execute" {

  # Deploy networking + cluster + worker defined in tests subdir

  module {
    source = "./tests"
  }

  assert {
    condition     = module.cluster.cluster_name == "stackx-cluster"
    error_message = "Cluster name did not match expected"
  }
}
