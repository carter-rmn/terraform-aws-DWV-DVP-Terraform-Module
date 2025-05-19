resource "aws_s3_bucket" "s3s" {
  for_each = local.s3s
  bucket   = "${local.dwv_prefix}-s3-${each.key}"

  tags = {
    Name        = "${local.dwv_prefix}-s3-${each.key}"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
