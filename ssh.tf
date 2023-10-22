# --------------------------------------------------------------------------
# Key Pair for SSH access to EKS worker nodes (for debugging)
# --------------------------------------------------------------------------
resource "tls_private_key" "ssh" {
  count = var.aws_key_name == "" ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  count = var.aws_key_name == "" ? 1 : 0

  key_name   = substr(lower(var.cluster_name), 0, 254)
  public_key = tls_private_key.ssh.0.public_key_openssh
}

resource "aws_security_group" "ssh" {
  count = var.ssh_allow_workstation ? 1 : 0

  # Up to 255 characters in length. Cannot start with sg- .
  # a-z, A-Z, 0-9, spaces, and ._-:/()#,@[]+=&;{}!$*
  name        = substr(lower("ssh-${var.cluster_name}"), 0, 254)
  description = "Allow SSH access to EKS worker nodes from workstation IPv4 address"

  vpc_id = var.vpc_id

  tags = local.tags
}

data "http" "current_ipv4" {
  count = var.ssh_allow_workstation ? 1 : 0

  url = "https://ipv4.icanhazip.com"
}

resource "aws_security_group_rule" "current_ipv4" {
  count = var.ssh_allow_workstation ? 1 : 0

  description       = "Allow SSH from current workstation IPv4"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.current_ipv4.0.response_body)}/32"]
  type              = "ingress"
  security_group_id = aws_security_group.ssh.0.id
}

resource "aws_ssm_parameter" "ssh_pub" {
  count = var.aws_key_name == "" && var.key_storage == "ssm" ? 1 : 0

  name        = "/clients/${var.cluster_name}/eks/worker/id_rsa.pub"
  type        = "String"
  description = "SSH Public Key for ${var.cluster_name} Worker Nodes"
  value       = tls_private_key.ssh.0.public_key_openssh

  tags = local.tags
}

resource "aws_ssm_parameter" "ssh_private" {
  count = var.aws_key_name == "" && var.key_storage == "ssm" ? 1 : 0

  name        = "/clients/${var.cluster_name}/eks/worker/id_rsa"
  description = "SSH Private Key for ${var.cluster_name} Worker Nodes"
  type        = "SecureString"
  value       = tls_private_key.ssh.0.private_key_pem

  tags = local.tags
}

resource "aws_secretsmanager_secret" "ssh_public" {
  count = var.aws_key_name == "" && var.key_storage == "secretsmanager" ? 1 : 0

  # https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_limits.html
  # Secret names must use Unicode characters.
  # Secret names contain 1-512 characters.
  name = substr(lower("ssh-public-${var.cluster_name}"), 0, 511)

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "ssh_public" {
  count = var.aws_key_name == "" && var.key_storage == "secretsmanager" ? 1 : 0

  secret_id     = aws_secretsmanager_secret.ssh_public.0.id
  secret_string = tls_private_key.ssh.0.public_key_openssh
}

resource "aws_secretsmanager_secret" "ssh_private" {
  count = var.aws_key_name == "" && var.key_storage == "secretsmanager" ? 1 : 0

  # https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_limits.html
  # Secret names must use Unicode characters.
  # Secret names contain 1-512 characters.
  name = substr(lower("ssh-private-${var.cluster_name}"), 0, 511)

  recovery_window_in_days = 7

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "ssh_private" {
  count = var.aws_key_name == "" && var.key_storage == "secretsmanager" ? 1 : 0

  secret_id     = aws_secretsmanager_secret.ssh_private.0.id
  secret_string = tls_private_key.ssh.0.private_key_pem
}
