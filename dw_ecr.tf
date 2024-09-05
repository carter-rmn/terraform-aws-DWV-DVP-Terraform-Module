resource "aws_ecr_repository" "ecrs" {
  for_each = var.ecr.ecr
  name                 = "${local.dwv_prefix}-ecr-${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${local.dwv_prefix}-ecr-${each.key}"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}