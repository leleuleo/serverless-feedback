resource "aws_iam_role" "lambda_role" {
  name = "lambda_dynamodb_sns_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_dynamodb_sns_policy"
  description = "Permite que o Lambda acesse DynamoDB e publique no SNS"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:PutItem", "dynamodb:Scan"]  # ✅ Adicionamos dynamodb:Scan
        Effect   = "Allow"
        Resource = aws_dynamodb_table.feedback_table.arn
      },
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = aws_sns_topic.feedback_notifications.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "feedback_lambda" {
  filename         = "../lambda/lambda.zip"
  function_name    = "feedback_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = 10

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.feedback_table.name
      SNS_TOPIC_ARN  = aws_sns_topic.feedback_notifications.arn  # Adicionamos a variável do SNS
    }
  }
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.feedback_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "LambdaLoggingPolicy"
  description = "Permite que a Lambda grave logs no CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "LambdaDynamoDBPolicy"
  description = "Permite que a Lambda acesse o DynamoDB para leitura e escrita"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:us-east-1:891612569598:table/Feedbacks"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}