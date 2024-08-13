output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}

output "sg_eks" {
  value = aws_eks_cluster.data_weaver_eks_cluster.vpc_config[0].cluster_security_group_id
}