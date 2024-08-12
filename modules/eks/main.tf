resource "aws_eks_cluster" "data_weaver_eks_cluster" {
  name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-eks-cluster"
  enabled_cluster_log_types = ["api", "audit", "authenticator","controllerManager","scheduler"]
  role_arn                  = aws_iam_role.data_weaver_eks.arn
  version                   = var.aws_eks_cluster_version

  vpc_config {
    endpoint_public_access    = true
    subnet_ids                = var.private_id
    security_group_ids        = [aws_security_group.sg_eks.id]
  }

   tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-eks"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }

}
### Adding Fargate profile for EKS cluster ###
resource "aws_eks_fargate_profile" "data_weaver_eks_fargate" {
  cluster_name           = aws_eks_cluster.data_weaver_eks_cluster.name
  fargate_profile_name   = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-eks-fargate-profile"
  pod_execution_role_arn = aws_iam_role.data_weaver_fargate.arn
  subnet_ids             = var.private_id

  selector {
    namespace = "${var.fargate_namespace_1}"
  }
  selector {
    namespace = "${var.fargate_namespace_2}"
  }
  selector {
    namespace = "${var.fargate_namespace_3}"
  }
  selector {
    namespace = "${var.fargate_namespace_4}"
  }
  selector {
    namespace = "${var.fargate_namespace_5}"
  }

}
resource "aws_iam_role" "data_weaver_fargate" {
  name = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-eks-fargate-profile"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_policy" "EksFargatePodExecutionRolePolicy" {
  name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-EksFargatePodExecutionRole-policy"
  description = "Policy for EKS Fargate Pod Execution Role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ecr:*",
          "ecs:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
        ]
        Resource = [
          "arn:aws:eks:us-east-1:760088588455:cluster/dev-data-weaver",
          "arn:aws:eks:us-east-1:760088588455:cluster/dev-test",
          "*",
          "arn:aws:ecr:us-east-1:760088588455:repository/*"
        ]
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "EksFargatePodExecutionRolepolicy" {
  policy_arn = aws_iam_policy.EksFargatePodExecutionRolePolicy.arn
  role       = aws_iam_role.data_weaver_fargate.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.data_weaver_fargate.name
}
resource "aws_iam_role" "data_weaver_eks" {
  name               = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-eks-cluster-iam-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.data_weaver_eks.name
}
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.data_weaver_eks.name
}
data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.data_weaver_eks_cluster.id
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.data_weaver_eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.data_weaver_eks_cluster.identity.0.oidc.0.issuer
}
data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:fargate-container-insights:adot-collector"]
    }
    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role_policy.json
  name               = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-aws-load-balancer-controller"
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  policy = file("${path.module}/AWSLoadBalancerController.json")
  name   = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-AWSLoadBalancerController"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}
