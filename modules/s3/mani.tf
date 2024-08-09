resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name_1

  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-s3-bucket"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}