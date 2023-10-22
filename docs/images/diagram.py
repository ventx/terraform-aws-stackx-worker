from diagrams import Cluster, Diagram
from diagrams.aws.compute import ElasticKubernetesService, EC2
from diagrams.aws.compute import Fargate
from diagrams.aws.security import KeyManagementService
from diagrams.aws.security import IdentityAndAccessManagementIam
from diagrams.aws.security import IdentityAndAccessManagementIamRole



with Diagram("terraform-aws-stackx-worker", outformat="png", filename="screenshot1", show=False):
  with Cluster("EKS"):

          eks = ElasticKubernetesService("EKS")
          fg = Fargate("Fargate Profile")

          with Cluster("Worker Nodes"):
              worker_nodes = EC2("Worker Nodes")  # Representing Worker Nodes using EC2 service
              eks >> worker_nodes  # Connecting EKS to Worker Nodes
