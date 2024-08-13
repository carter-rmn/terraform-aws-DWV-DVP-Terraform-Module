resource "aws_s3_bucket" "bucket" {
  for_each = {for key in var.s3.names : key=>key}
  bucket = each.key

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-s3-bucket-${each.key}"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}