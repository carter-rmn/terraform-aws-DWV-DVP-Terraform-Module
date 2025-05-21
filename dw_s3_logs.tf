resource "aws_s3_bucket_logging" "s3s" {
  for_each      = contains(keys(aws_s3_bucket.s3s), "log") ? local.s3s : {}
  bucket        = aws_s3_bucket.s3s[each.key].id
  target_bucket = aws_s3_bucket.s3s["log"].id
  target_prefix = each.key
}

resource "aws_s3_bucket_lifecycle_configuration" "log" {
  count  = contains(keys(aws_s3_bucket.s3s), "log") ? 1 : 0
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
