resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name_1

  tags = {
    Name        = var.bucket_name_1
    terraform   = "true"
  }
}