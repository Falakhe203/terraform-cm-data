resource "aws_cloudwatch_log_group" "lambda" {
    name = "/aws/lambda/${var.lambda_function_name}"
    retention_in_days = var.log_retention
    #checkov:skip=CKV_AWS_158:Log encryption has to be decided
}