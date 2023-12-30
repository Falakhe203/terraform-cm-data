data "aws_ssm_parameter" "itsm_gw_api_key" {
  name = "/itsm_gw_api_key"
}

resource "aws_lambda_function" "lambda" {
    function_name = var.lambda_function_name
    role = aws_iam_role.lambda.arn
    filename = data.archive_file.lambda-code.output_path 
    source_code_hash = data.archive_file.lambda-code.base64sha256
    handler = "itsm_forwarder.notify.handler"
    runtime = "python3.9"
    package_type = "Zip"
    timeout = var.lambda_timeout
    reserved_concurrent_executions = 1  # function should not run concurrently
    memory_size = var.lambda_memory
    layers = var.lambda_layers

    environment {
      variables = merge(var.lambda_inputs, {API_KEY = data.aws_ssm_parameter.itsm_gw_api_key.value})
    }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.itsm_forwarder.function_name
  principal = "sns.amazonaws.com"
  source_arn = aws__sns_topic.itsm_forwarder.arn
}

data "archive_file" "lambda-code" {
    type = "zip"
    source_dir = "${path.module}/python_logic"
    output_path = "${path.module}/build/${var.lambda_function_name}.zip"
}