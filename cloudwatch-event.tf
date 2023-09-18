resource "aws_cloudwatch_event_rule" "monthly" {
  name                = "run-monthly"
  description         = "Fires every month"
  schedule_expression = "rate(1 month)"
}

resource "aws_cloudwatch_event_target" "monthly_lambda" {
  rule      = aws_cloudwatch_event_rule.monthly.name
  target_id = "checkCostIncreaseLambda"
  arn       = aws_lambda_function.check_cost_increase.arn
}
