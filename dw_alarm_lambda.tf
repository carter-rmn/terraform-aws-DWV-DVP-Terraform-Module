resource "aws_lambda_function" "slack_notification" {
  filename      = "../data/slack_notification_lambda.py.zip"
  function_name = "${local.dwv_prefix}-lambda-slack"
  role          = aws_iam_role.lambda_execution.arn
  handler       = "slack_notification_lambda.lambda_handler"
  runtime       = "python3.13"

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.WEBHOOK_SLACK
    }
  }

  tags = {
    Name        = "${local.dwv_prefix}-lambda-slack"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alarms.arn
}
