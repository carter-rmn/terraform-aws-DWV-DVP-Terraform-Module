resource "tls_private_key" "ec2s" {
  for_each = var.key_pair.keys
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2s" {
  for_each = var.key_pair.keys
  key_name   = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-ec2-${each.key}"
  public_key = tls_private_key.ec2s[each.key].public_key_openssh

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-ec2-${each.key}"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
