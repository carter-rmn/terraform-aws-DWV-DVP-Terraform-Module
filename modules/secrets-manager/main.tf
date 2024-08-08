resource "aws_secretsmanager_secret" "secret_ec2s" {
  name     = var.secret_name

  tags = {
    Name        = var.secret_name
    Terraform   = true
  }
}