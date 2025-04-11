resource "aws_s3_bucket_logging" "s3s" {
  for_each      = { for key in var.s3.names : key => key }
  bucket        = aws_s3_bucket.s3s[each.key].id
  target_bucket = aws_s3_bucket.s3s["log"].id
  target_prefix = each.key
}

resource "aws_s3_bucket_lifecycle_configuration" "log" {
  bucket = aws_s3_bucket.s3s["log"].id

  rule {
    id     = "${local.dwv_prefix}-s3-lifecycle-logs"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 30
    }
  }
}
