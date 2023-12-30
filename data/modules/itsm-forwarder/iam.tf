resource "aws_iam_role" "lambda" {
    name = "${var.lambda_function_name}-role"
    assume_role_policy = file("${path.module}/policies/lambda_assume_role_policy.json")
}

resource "aws_iam_role_policy" "logging" {
    name = "${var.lambda_function_name}-logging"
    role = aws_iam_role.lambda.name
    policy = templatefile(
        "${path.module}/policies/lambda_logging.json", {
            lambda_function_name = var.lambda_function_name
        }
    )
}

resource "aws_iam_role_policy" "describe" {
    name = "${var.lambda_function_name}-describe"
    role = aws_iam_role.lambda.name
    policy = templatefile(
        "${path.module}/policies/lambda_describe.json", {
            lambda_function_name = var.aws_account_id
        }
    )
}