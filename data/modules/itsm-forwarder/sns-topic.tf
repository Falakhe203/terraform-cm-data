resource "aws_sns_topic" "itsm_forwarder" {
    name = "itsm_forwarder"
}

resource "aws_sns_topic_subscription" "itsm_lambda_target" {
    topic_arn = aws_sns_topic.itsm_forwarder.arn
    protocol = "lambda"
    endpoint = aws_lambda_function.itsm_forwarder
}