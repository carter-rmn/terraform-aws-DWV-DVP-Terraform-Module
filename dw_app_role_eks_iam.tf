data "aws_iam_policy_document" "pod_identity_assume_role" {
  for_each = local.app_roles_eks

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole", "sts:TagSession"]
  }
}

resource "aws_iam_role" "app_role_eks" {
  for_each = local.app_roles_eks

  name               = "${local.dwv_prefix}-iam-role-app-${each.key}"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role[each.key].json

  tags = merge(local.common_tags, {
    Name = "${local.dwv_prefix}-iam-role-app-${each.key}"
  })
}

resource "aws_iam_policy" "app_role_policies" {
  for_each = {
    for name, config in local.app_roles_eks : name => config if length(config) > 0
  }

  name        = "${local.dwv_prefix}-iam-policy-app-${each.key}"
  description = "Custom policy for ${each.key} application role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = flatten([
      for policy_name, policy_config in each.value : [
        {
          Effect   = policy_config.effect
          Action   = policy_config.actions
          Resource = policy_config.resource
        }
      ]
    ])
  })

  tags = merge(local.common_tags, {
    Name = "${local.dwv_prefix}-iam-policy-app-${each.key}"
  })
}

resource "aws_iam_role_policy_attachment" "app_role_custom_policies" {
  for_each = {
    for name, config in local.app_roles_eks : name => config if length(config) > 0
  }

  role       = aws_iam_role.app_role_eks[each.key].name
  policy_arn = aws_iam_policy.app_role_policies[each.key].arn
}