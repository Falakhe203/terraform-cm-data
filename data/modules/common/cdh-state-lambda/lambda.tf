resource "aws_lambda_function" "lambda" {
    function_name = var.lambda_function_name
    role = aws_iam_role.lambda.arn
    filename = data.archive_file.lambda-code.output_path 
    source_code_hash = data.archive_file.lambda-code.base64sha256
    handler = var.lambda_handler
    runtime = "python3.9"
    package_type = "Zip"
    timeout = var.lambda_timeout
    reserved_concurrent_executions = 1  # function should not run concurrently
    memory_size = var.lambda_memory
    layers = var.lambda_layers

    environment {
      variables = var.lambda_inputs
    }
}

data "archive_file" "lambda-code" {
    type = "zip"
    source_dir = var.lambda_code_path
    output_path = "${path.module}/build/${var.lambda_function_name}.zip"
}