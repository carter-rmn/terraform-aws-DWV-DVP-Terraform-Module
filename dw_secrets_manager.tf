resource "aws_secretsmanager_secret" "secret_ec2s" {
  for_each = var.secrets-manager.keys
  name     = "${local.dwv_prefix}-secret-key-${each.key}"

  tags = {
    Name        = "${local.dwv_prefix}-secret-key-${each.key}"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_secretsmanager_secret" "dwv_secret_terraform" {
  count   = var.secrets-manager.create ? 1 : 0
  name = "${local.dwv_prefix}-secret-terraform"
  tags = {
    Name        = "${local.dwv_prefix}-secret-terraform"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_secretsmanager_secret" "dwv_secret_others" {
  count   = var.secrets-manager.create ? 1 : 0
  name = "${local.dwv_prefix}-secret-others"
  tags = {
    Name        = "${local.dwv_prefix}-secret-others"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}