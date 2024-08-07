resource "aws_apigatewayv2_api" "odin_rmn_http_api" {
  name          = var.odin-rmn-api-gateway-name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "odin_rmn_vpc_link" {
  name          = var.odin-rmn-vpc-link-name
  security_group_ids = [var.security_group_ids]
  subnet_ids    = var.subnet_ids
}

resource "aws_apigatewayv2_integration" "odin_rmn_alb_integration" {
  api_id        = aws_apigatewayv2_api.odin_rmn_http_api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  description        = "VPC integration"
  connection_id = aws_apigatewayv2_vpc_link.odin_rmn_vpc_link.id
  #integration_uri = aws_lb_listener.odin_listener.arn
  integration_uri = var.odi_rmn_alb_listener_arn
}

resource "aws_apigatewayv2_route" "odin_rmn_api_route" {
  api_id    = aws_apigatewayv2_api.odin_rmn_http_api.id
  route_key = "ANY /api/v1/public/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.odin_rmn_alb_integration.id}"
}


resource "aws_apigatewayv2_domain_name" "odin_rmn_custom_domain" {
  domain_name = var.odin_rmn_domain_name
  domain_name_configuration {
    certificate_arn         = var.odin_rmn_web_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
resource "aws_apigatewayv2_stage" "odin_rmn_stage" {
  api_id      = aws_apigatewayv2_api.odin_rmn_http_api.id
  name        = var.odin-rmn-stage-name
  auto_deploy = true
}
resource "aws_apigatewayv2_api_mapping" "mapping" {
  domain_name = aws_apigatewayv2_domain_name.odin_rmn_custom_domain.domain_name
  stage       = aws_apigatewayv2_stage.odin_rmn_stage.name
  api_id      = aws_apigatewayv2_api.odin_rmn_http_api.id
}
resource "aws_route53_record" "odi_rmn_api_custom_domain" {
  zone_id = var.hosted_zone_id
  name    = var.odin_rmn_domain_name
  type    = "A"
  alias {
    name                   = aws_apigatewayv2_domain_name.odin_rmn_custom_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.odin_rmn_custom_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
