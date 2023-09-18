resource "aws_lambda_function" "check_cost_increase" {
  filename      = "lambda_function_payload.zip"
  function_name = "checkCostIncrease"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.8"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  depends_on = [null_resource.zip_lambda]
}
resource "aws_iam_role" "lambda_exec" {
  name = "role_lambda_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })  
  depends_on = [null_resource.zip_lambda]
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSPriceListServiceFullAccess"
}
