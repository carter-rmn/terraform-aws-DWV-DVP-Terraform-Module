output "tls_private_key" {
  value = tls_private_key.ec2s[each.key].private_key_pem
}