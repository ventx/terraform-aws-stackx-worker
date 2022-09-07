# --------------------------------------------------------------------------
# Lookup latest Bottlerocket AMI
# --------------------------------------------------------------------------
#data "aws_ssm_parameter" "image_id" {
#  name = "/aws/service/bottlerocket/aws-k8s-${var.cluster_version}/${var.arch}/latest/image_id"
#}
#
#data "aws_ami" "image" {
#  owners = ["amazon"]
#
#  filter {
#    name   = "image-id"
#    values = [data.aws_ssm_parameter.image_id.value]
#  }
#}

# Get the current AWS partition (aws, aws-cn, aws-us-gov)
data "aws_partition" "current" {}
