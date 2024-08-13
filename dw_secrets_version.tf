resource "aws_secretsmanager_secret_version" "secret_ec2s" {
  for_each = var.secrets-version.keys
  secret_id     = aws_secretsmanager_secret.secret_ec2s[each.key].id
  secret_string = tls_private_key.ec2s[each.key].private_key_pem
}