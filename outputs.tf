output "api_gateway_url" {
  description = "URL de endpoint da API Gateway"
  value       = "https://${aws_api_gateway_rest_api.feedback_api.id}.execute-api.us-east-1.amazonaws.com/prod/feedback"
}
