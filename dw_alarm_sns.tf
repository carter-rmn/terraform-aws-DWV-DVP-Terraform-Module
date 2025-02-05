resource "aws_sns_topic" "alarms" {
  name = "${local.dwv_prefix}-sns-topic-alarms"
  tags = {
    Name        = "${local.dwv_prefix}-sns-topic-alarms"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_sns_topic_subscription" "slack" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.slack_notification.arn
}
resource "aws_sns_topic_subscription" "emails" {
  for_each  = { for email in var.alarm.emails : email => email }
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = each.value
}
