resource "aws_ecr_repository" "ecrs" {
  for_each             = var.ecr.ecr
  name                 = "${local.dwv_prefix}-ecr-dwv-${each.key}"
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

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  for_each = var.ecr.ecr
  repository = aws_ecr_repository.ecrs[each.key].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 5 images",
            "selection": {
                "tagStatus": "any",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}