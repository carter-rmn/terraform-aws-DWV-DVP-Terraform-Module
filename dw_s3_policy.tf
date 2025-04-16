resource "aws_s3_bucket_public_access_block" "s3s" {
  for_each                = local.s3s
  bucket                  = aws_s3_bucket.s3s[each.key].id
  block_public_acls       = !each.value.publicly_readable
  block_public_policy     = !each.value.publicly_readable
  ignore_public_acls      = !each.value.publicly_readable
  restrict_public_buckets = !each.value.publicly_readable
}

resource "aws_s3_bucket_versioning" "s3s" {
  for_each = local.s3s
  bucket   = aws_s3_bucket.s3s[each.key].id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "s3s" {
  for_each = local.s3s
  bucket   = aws_s3_bucket.s3s[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSSLRequestsOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = "${aws_s3_bucket.s3s[each.key].arn}/*"
        Condition = {
          Bool = {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })
}
