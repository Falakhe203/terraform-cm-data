resource "aws_lambda_function_event_invoke_config" "start-next-lambda" {
    function_name = aws_lambda_function.lambda.function_name 
    count = var.start_next_lambda ? 1 : 0

    destination_config {
        on_success {
            destination = var.start_next_lambda_arn
        }
    }
}