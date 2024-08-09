resource "aws_secretsmanager_secret_version" "secret_ec2s" {
  #for_each = local.keys
  secret_id     = aws_secretsmanager_secret.rmn_secret_ec2s[each.key].id
  secret_string = var.secret_string
}