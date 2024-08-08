resource "tls_private_key" "private_key_data_weaver" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key_data_weaver" {
  key_name   = var.key_name_odin
  public_key = tls_private_key.private_key_data_weaver.public_key_openssh
}

resource "aws_instance" "instance_name_data_weaver" {
    ami                         = var.instance_ami_odin
    instance_type               = var.instance_type_odin
    subnet_id                   = var.subnet_id_odin
    vpc_security_group_ids      = [var.vpc_security_group_ids]
    user_data                   = "${file("./modules/data-weaver-ec2-instance/db.sh")}"
    associate_public_ip_address = true
    iam_instance_profile        = var.instance_profile
    key_name                    = aws_key_pair.generated_key_data_weaver.key_name

  root_block_device {
    volume_size = var.volume_size_odin
    tags = {
      Name        = var.ebs_name
      Project     = var.project_name
      Customer    = var.PROJECT_CUSTOMER
      Environment = var.PROJECT_ENV
      Terraform   = true
    }
    volume_type = var.volume_type_odin
  }
  tags = {
      Name        = var.instance_name_odin
      Project     = var.project_name
      Customer    = var.PROJECT_CUSTOMER
      Environment = var.PROJECT_ENV
      Terraform   = true
    }
}
# resource "aws_s3_bucket_object" "object" {
#  bucket = var.bucket_name_odin
#  key    = var.filename_odin
#  #source = var.filename_odin
# }