resource "aws_secretsmanager_secret" "secret_ec2s" {
  for_each = var.secrets-manager.keys
  name     = "${local.dwv_prefix}-secret-key-${each.key}"

  tags = {
    Name        = "${local.dwv_prefix}-secret-key-${each.key}"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
