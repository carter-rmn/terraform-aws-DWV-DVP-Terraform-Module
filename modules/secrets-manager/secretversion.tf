resource "aws_secretsmanager_secret_version" "secret_ec2s" {
  secret_id     = aws_secretsmanager_secret.secret_ec2s.id
  secret_string = var.secret_string
}