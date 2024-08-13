resource "aws_secretsmanager_secret" "secret_ec2s" {
  for_each = var.keys
  name     = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-secret-key-${each.key}"

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-secret-key-${each.key}"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
resource "aws_secretsmanager_secret_version" "secret_ec2s" {
  for_each = var.keys
  secret_id     = aws_secretsmanager_secret.secret_ec2s[each.key].id
  secret_string = var.secret_string[each.key]
  depends_on = [aws_secretsmanager_secret.secret_ec2s]
}