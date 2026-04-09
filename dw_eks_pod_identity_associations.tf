resource "aws_eks_pod_identity_association" "apps" {
  for_each = (var.CREATE_IAM && var.pod_identity.enabled) ? var.pod_identity.apps : {}

  cluster_name    = var.eks.create ? aws_eks_cluster.main[0].name : var.eks.existing.name
  namespace       = var.PROJECT_ENV
  service_account = "${local.dwv_prefix}-${each.key}"
  role_arn        = aws_iam_role.app_role_eks[each.value.role_key].arn

  tags = merge(local.common_tags, {
    Name = "${local.dwv_prefix}-pod-identity-${each.key}"
  })
}