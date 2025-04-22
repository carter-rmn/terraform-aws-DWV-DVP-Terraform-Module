resource "aws_instance" "ec2s" {
  for_each      = var.CREATE_NON_IAM ? var.ec2.instances : {}
  ami           = var.ec2.ami
  instance_type = each.value.instance_type
  key_name      = "${local.dwv_prefix}-ec2-${element(split("-", each.key), 0)}"
  user_data                   = file("${path.module}/db.sh")
  vpc_security_group_ids = [aws_security_group.sg_mongo.id,aws_security_group.sg_ssh.id]
  subnet_id = element(
  each.value.public ? var.vpc.subnets.public : var.vpc.subnets.private,
  each.value.subnet_index
)
  associate_public_ip_address = each.value.public
  iam_instance_profile = each.value.instance_profile

  root_block_device {
    volume_size = each.value.volume_size
    tags = {
      Name        = "${local.dwv_prefix}-ebs-${each.key}"
      Project     = local.dwv_project_name
      Customer    = var.PROJECT_CUSTOMER
      Environment = var.PROJECT_ENV
      Terraform   = true
  }
  }

  tags = {
    Name        = "${local.dwv_prefix}-ec2-${each.key}"
    Short       = "${each.key}"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}