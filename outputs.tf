output "key_pair" {
  value = {
    for key, key_pair in tls_private_key.ec2s : key => key_pair.private_key_pem
  }
}

output "ec2_instance_private_ip" {
  value       = {
    for key, instance in aws_instance.ec2s :
    key => instance.private_ip
  }
}

output "ec2_instance_public_ip" {
  value       = {
    for key, instance in aws_instance.ec2s :
    key => instance.public_ip
  }
}

output "ec2_instance_private_dns" {
  value       = {
    for key, instance in aws_instance.ec2s :
    key => instance.private_dns
  }
}

output "ec2_instance_public_dns" {
  value       = {
    for key, instance in aws_instance.ec2s :
    key => instance.public_dns
  }
}
