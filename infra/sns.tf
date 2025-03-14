resource "aws_sns_topic" "feedback_notifications" {
  name = "feedback_notifications"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.feedback_notifications.arn
  protocol  = "email"
  endpoint  = "leonardol.rodrigues@hotmail.com"  # Substitua pelo seu e-mail para receber as notificações
}
