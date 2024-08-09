resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-api-gateway-odin"
  protocol_type = "HTTP"
   tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-api-gateway-odin"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_apigatewayv2_vpc_link" "odin_vpc_link" {
  name          = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-vpc-link-odin"
  security_group_ids = [var.security_group_ids]
  subnet_ids    = var.subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-vpc-link-odin"
    Project     = var.project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
  
}

resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id        = aws_apigatewayv2_api.http_api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  description        = "VPC integration"
  connection_id = aws_apigatewayv2_vpc_link.odin_vpc_link.id
  integration_uri = var.integration_uri
}

resource "aws_apigatewayv2_route" "api_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /api/v1/public/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}


resource "aws_apigatewayv2_domain_name" "custom_domain" {
  domain_name = var.domain_name
  domain_name_configuration {
    certificate_arn         = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
resource "aws_apigatewayv2_stage" "odin_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "${var.project_name}-${var.PROJECT_CUSTOMER}-${var.PROJECT_ENV}-stage-odin"
  auto_deploy = true
}
resource "aws_apigatewayv2_api_mapping" "mapping" {
  domain_name = aws_apigatewayv2_domain_name.custom_domain.domain_name
  stage       = aws_apigatewayv2_stage.odin_stage.name
  api_id      = aws_apigatewayv2_api.http_api.id
}
resource "aws_route53_record" "api_custom_domain" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_apigatewayv2_domain_name.custom_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.custom_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
