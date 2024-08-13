# output "tls_private_key" {
#   value = tls_private_key.ec2s[each.key].private_key_pem
# }

output "tls_private_keys" {
  description = "Map of private keys"
  value = { for key, key_pair in tls_private_key.ec2s : key => key_pair.private_key_pem }
}