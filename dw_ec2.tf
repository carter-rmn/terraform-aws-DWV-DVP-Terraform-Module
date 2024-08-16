resource "aws_instance" "ec2s" {
  for_each = var.ec2.instances
  ami           = var.ec2.ami
  instance_type = each.value.instance_type
  key_name      = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-ec2-${element(split("-", each.key), 0)}"
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
      Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-ebs-${each.key}"
      Project     = var.project_name
      Customer    = var.PROJECT_CUSTOMER
      Environment = var.PROJECT_ENV
      Terraform   = true
  }
  }

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-ec2-${each.key}"
    Short       = "${each.key}"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}