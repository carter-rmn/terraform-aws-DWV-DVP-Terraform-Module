resource "aws_secretsmanager_secret_version" "secret_ec2s" {
  for_each = var.keys
  secret_id     = var.secret_id
  secret_string = var.secret_string
  #depends_on = [aws_secretsmanager_secret.secret_ec2s]
}