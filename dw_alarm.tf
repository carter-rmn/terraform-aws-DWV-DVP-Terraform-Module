resource "aws_cloudwatch_metric_alarm" "ec2s" {
  for_each            = { for alarm in local.alarm.ec2 : alarm.name => alarm }
  alarm_name          = "${local.dwv_prefix}-alarm-ec2-${each.value.alarm.alarm_name}-${each.value.ec2_name}"
  comparison_operator = each.value.alarm.comparison_operator
  evaluation_periods  = each.value.alarm.evaluation_periods
  metric_name         = each.value.alarm.metric_name
  namespace           = each.value.alarm.namespace
  period              = each.value.alarm.period
  statistic           = each.value.alarm.statistic
  threshold           = each.value.alarm.threshold
  alarm_description   = "${each.value.alarm.metric_name} has been ${regex("^(Greater|Less)", each.value.alarm.comparison_operator)[0]} than the threshold of ${each.value.alarm.threshold} for ${each.value.alarm.evaluation_periods} consecutive periods"
  treat_missing_data  = each.value.alarm.treat_missing_data
  dimensions          = { "InstanceId" = aws_instance.ec2s[each.value.ec2_name].id }
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarms.arn]

  tags = {
    Name        = "${local.dwv_prefix}-alarm-ec2-${each.value.alarm.alarm_name}-${each.value.ec2_name}"
    Project     = local.dwv_project_name
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}
