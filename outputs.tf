output "key_pair" {
  value = {
    for key, key_pair in tls_private_key.ec2s : key => key_pair.private_key_pem
  }
}