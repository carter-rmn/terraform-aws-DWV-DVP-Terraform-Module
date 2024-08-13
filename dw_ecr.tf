resource "aws_ecr_repository" "ecrs" {
  for_each = var.ecr
  name                 = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-ecr-${each.key}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-ecr-${each.key}"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}