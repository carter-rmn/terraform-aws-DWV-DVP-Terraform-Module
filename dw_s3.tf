resource "aws_s3_bucket" "s3s" {
  for_each = { for key in var.s3.names : key => key }
  bucket   = each.key

  tags = {
    Name        = "${local.dwv_prefix}-s3-bucket-${each.key}"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
