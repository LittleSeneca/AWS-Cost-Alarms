resource "aws_cloudwatch_metric_alarm" "cost_increase_alarm" {
  alarm_name          = "CostIncreaseAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "YourCustomMetricName"  # Make sure this metric name matches the one your Lambda function sets
  namespace           = "YourCustomNamespace"
  period              = "2592000"  # 30 days in seconds
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "This metric checks if there's a cost increase of more than 10%"
  alarm_actions       = [aws_sns_topic.cost_increase_alarm.arn] # Notification for alarms
}

resource "aws_sns_topic" "cost_increase_alarm" {
  name = "cost-increase-alarm"
}
