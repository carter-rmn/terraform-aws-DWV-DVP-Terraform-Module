resource "aws_apigatewayv2_api" "http_api" {
  count                     = var.api-gateway.create ? 1 : 0
  name          = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-api-gateway-core"
  protocol_type = "HTTP"
   tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-api-gateway-core"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_apigatewayv2_vpc_link" "core_vpc_link" {
  count                     = var.api-gateway.create ? 1 : 0
  name          = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-vpc-link-core"
  security_group_ids = [aws_security_group.sg_eks]
  subnet_ids    = var.vpc.subnets.private
  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-vpc-link-core"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
  
}

resource "aws_apigatewayv2_integration" "alb_integration" {
  count                     = var.api-gateway.create ? 1 : 0
  api_id        = aws_apigatewayv2_api.http_api[0].id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  description        = "VPC integration"
  connection_id = aws_apigatewayv2_vpc_link.core_vpc_link[0].id
  integration_uri = var.api-gateway.integration_uri
}

resource "aws_apigatewayv2_route" "api_route" {
  count                     = var.api-gateway.create ? 1 : 0
  api_id    = aws_apigatewayv2_api.http_api[0].id
  route_key = "ANY /api/v1/public/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.alb_integration[0].id}"
}


resource "aws_apigatewayv2_domain_name" "custom_domain" {
  count                     = var.api-gateway.create ? 1 : 0
  domain_name = var.api-gateway.domain_name
  domain_name_configuration {
    certificate_arn         = var.api-gateway.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
resource "aws_apigatewayv2_stage" "core_stage" {
  count                     = var.api-gateway.create ? 1 : 0
  api_id      = aws_apigatewayv2_api.http_api[0].id
  name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-stage-core"
  auto_deploy = true
}
resource "aws_apigatewayv2_api_mapping" "mapping" {
  count                     = var.api-gateway.create ? 1 : 0
  domain_name = aws_apigatewayv2_domain_name.custom_domain[0].domain_name
  stage       = aws_apigatewayv2_stage.core_stage[0].name
  api_id      = aws_apigatewayv2_api.http_api[0].id
}
resource "aws_route53_record" "api_custom_domain" {
  count                     = var.api-gateway.create ? 1 : 0
  zone_id = var.api-gateway.hosted_zone_id
  name    = var.api-gateway.domain_name
  type    = "A"
  alias {
    name                   = aws_apigatewayv2_domain_name.custom_domain[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.custom_domain[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
