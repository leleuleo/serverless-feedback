resource "aws_api_gateway_rest_api" "feedback_api" {
  name        = "FeedbackAPI"
  description = "API para cadastrar e consultar feedbacks"
}

resource "aws_api_gateway_resource" "feedback_resource" {
  rest_api_id = aws_api_gateway_rest_api.feedback_api.id
  parent_id   = aws_api_gateway_rest_api.feedback_api.root_resource_id
  path_part   = "feedback"
}

resource "aws_api_gateway_method" "post_feedback" {
  rest_api_id   = aws_api_gateway_rest_api.feedback_api.id
  resource_id   = aws_api_gateway_resource.feedback_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_feedback" {
  rest_api_id   = aws_api_gateway_rest_api.feedback_api.id
  resource_id   = aws_api_gateway_resource.feedback_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_feedback_integration" {
  rest_api_id = aws_api_gateway_rest_api.feedback_api.id
  resource_id = aws_api_gateway_resource.feedback_resource.id
  http_method = aws_api_gateway_method.post_feedback.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.feedback_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "get_feedback_integration" {
  rest_api_id = aws_api_gateway_rest_api.feedback_api.id
  resource_id = aws_api_gateway_resource.feedback_resource.id
  http_method = aws_api_gateway_method.get_feedback.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.feedback_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.post_feedback_integration, aws_api_gateway_integration.get_feedback_integration]
  rest_api_id = aws_api_gateway_rest_api.feedback_api.id
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.feedback_api.id
  stage_name    = "prod"
}