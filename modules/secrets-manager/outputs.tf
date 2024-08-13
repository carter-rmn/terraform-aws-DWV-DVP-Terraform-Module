output "secret_id" {
  value = {
    for key, secret in aws_secretsmanager_secret.secret_ec2s : key => secret.id
  }
}