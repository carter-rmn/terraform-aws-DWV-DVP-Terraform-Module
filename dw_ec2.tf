resource "aws_instance" "ec2s" {
  for_each      = var.CREATE_NON_IAM ? var.ec2.instances : {}
  ami           = var.ec2.ami
  instance_type = each.value.instance_type
  key_name      = "${local.dwv_prefix}-ec2-${element(split("-", each.key), 0)}"

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  user_data              = file("${path.module}/db.sh")
  vpc_security_group_ids = compact([
  length(aws_security_group.sg_mongo) > 0 ? aws_security_group.sg_mongo[0].id : null,
  length(aws_security_group.sg_ssh) > 0 ? aws_security_group.sg_ssh[0].id : null
  ])
  subnet_id = element(
    each.value.public ? var.vpc.subnets.public : var.vpc.subnets.private,
    each.value.subnet_index
  )
  associate_public_ip_address = each.value.public
  iam_instance_profile        = each.value.instance_profile

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
