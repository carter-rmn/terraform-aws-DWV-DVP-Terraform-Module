resource "aws_eks_pod_identity_association" "apps" {
  for_each = (var.CREATE_IAM && var.pod_identity.enabled) ? var.pod_identity.apps : {}

  cluster_name    = var.eks.create ? aws_eks_cluster.data_weaver_eks_cluster[0].name : var.eks.existing.name
  namespace       = var.PROJECT_ENV
  service_account = "${local.dwv_prefix}-${each.key}"
  role_arn        = aws_iam_role.app_role_eks[each.value.role_key].arn

  tags = {
    Name        = "${local.dwv_prefix}-pod-identity-${each.key}"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
