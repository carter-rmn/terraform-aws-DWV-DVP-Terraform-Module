resource "aws_secretsmanager_secret" "secret_ec2s" {
  name     = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-secret-key-${each.key}"

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-secret-key-${each.key}"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}