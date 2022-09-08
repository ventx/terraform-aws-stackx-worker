from diagrams import Cluster, Diagram
from diagrams.aws.compute import ElasticKubernetesService
from diagrams.aws.security import KeyManagementService
from diagrams.aws.security import IdentityAndAccessManagementIam
from diagrams.aws.security import IdentityAndAccessManagementIamRole
from diagrams.aws.management import Cloudwatch


with Diagram("terraform-aws-stackx-worker", outformat="png", filename="screenshot1", show=False):
    with Cluster("EKS"):

      eks = ElasticKubernetesService("EKS")
      kms = KeyManagementService("Secrets Encryption")
      iam = IdentityAndAccessManagementIam("IAM")

      iam_group = [
        IdentityAndAccessManagementIam("IAM") >> IdentityAndAccessManagementIam("OIDC Provider"),
        IdentityAndAccessManagementIamRole("Cluster Role")
      ]
      cloudwatch = Cloudwatch("Control-Plane Logs")
      eks >> [kms, cloudwatch, iam_group]
