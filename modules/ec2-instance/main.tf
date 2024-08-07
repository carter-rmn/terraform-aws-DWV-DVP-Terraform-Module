resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}
resource "aws_instance" "instance_name_1" {
    ami                         = var.instance_ami
    instance_type               = var.instance_type
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = [var.vpc_security_group_ids]
    associate_public_ip_address = true
    key_name                    = aws_key_pair.generated_key.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = {
    Name = "${var.instance_name_1}"
    }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y gnupg curl",
      "curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor",
      "echo 'deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org",
      "sudo systemctl start mongod",
      "sudo systemctl enable mongod"
    ]
    connection {
       type        = "ssh"
       host        = aws_instance.instance_name_1.public_ip 
       user        = "ubuntu"
       private_key = file(var.filename)
    }
  }
 
}
resource "aws_instance" "instance_name_2" {
      ami                         = var.instance_ami
    instance_type               = var.instance_type
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = [var.vpc_security_group_ids]
    associate_public_ip_address = true
    key_name                    = aws_key_pair.generated_key.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = {
    Name = "${var.instance_name_2}"
    }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y gnupg curl",
      "curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor",
      "echo 'deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org",
      "sudo systemctl start mongod",
      "sudo systemctl enable mongod"
    ]
    connection {
       type        = "ssh"
       host        = aws_instance.instance_name_2.public_ip           
       user        = "ubuntu"
       private_key = file(var.filename)
    }
  }
 
}

#resource "local_file" "key" {
#  content  = tls_private_key.private_key.private_key_openssh
#  filename = var.filename
#}
#resource "aws_s3_bucket" "key_bucket" {
 # bucket = var.bucket_name
  #acl    = "private"
#}

# Upload PEM file to S3 bucket
resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = var.filename
  source = var.filename
}

# Delete local PEM file after upload
#resource "null_resource" "delete_local_file" {
 # triggers = {
  #  private_key_object_etag = aws_s3_object.object.etag
 # }

  #provisioner "local-exec" {
  #  command = "rm -f ${local_file.key.filename}"
  ##}
#}
# # resource "tls_private_key" "private_key_odin" {
# #   algorithm = "RSA"
# #   rsa_bits  = 4096
# # }

# # resource "aws_key_pair" "generated_key_odin" {
# #   key_name   = var.key_name_odin
# #   public_key = tls_private_key.private_key.public_key_openssh
# # }
# resource "aws_instance" "instance_name_odin" {
#     ami                         = var.instance_ami_odin
#     instance_type               = var.instance_type_odin
#     subnet_id                   = var.subnet_id_odin
#     vpc_security_group_ids      = [var.ecs_sg]
#     user_data                   = "${file("./modules/ec2-instance/db.sh")}"
#     associate_public_ip_address = true
#     iam_instance_profile        = var.instance_profile
#     key_name                    = aws_key_pair.generated_key.key_name
#     #key_name                    = var.key_name_odin

#   root_block_device {
#     volume_size = var.volume_size_odin
#     volume_type = var.volume_type_odin
#   }
#   tags = {
#     Name = "${var.instance_name_odin}"
#     }
# }