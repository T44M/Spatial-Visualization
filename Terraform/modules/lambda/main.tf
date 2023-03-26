resource "aws_lambda_function" "data_processing" {
  function_name = "dataProcessing"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda_function.zip"  #ÉçÅ[ÉJÉãÇ≈é©ï™Ç≈çÏÇÈÇ±Ç∆
}

resource "aws_iot_topic_rule" "data_processing_rule" {
  name        = "dataProcessingRule"
  description = "Forward data from IoT Core to Lambda function"

  rule_action {
    lambda {
      function_arn = aws_lambda_function.data_processing.arn
    }
  }

  sql        = "SELECT * FROM 'pub/myhome'"
  rule_disabled = false
  aws_iot_sql_version = "2016-03-23"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}
