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

resource "aws_iam_role_policy" "athena-access" {
    name = "${var.lambda_function_name}-athena-access"
    role = aws_iam_role.lambda.name
    policy = templatefile(
        "${path.module}/policies/athena_access.json", {
            aws_account_id = var.aws_account_id
        }
    )
}

resource "aws_iam_role_policy" "input-dataset-access" {
    name = "${var.lambda_function_name}-input-dataset-access"
    role = aws_iam_role.lambda.name
    policy = templatefile(
        "${path.module}/policies/input_dataset_access.json", {
            aws_account_id = var.aws_account_id
            input_s3_bucket = var.cdh_input_s3_bucket 
            input_kms_key_arn = var.cdh_input_s3_kms_key_arn
            input_catalog_aws_account_id = var.cdh_input_glue_catalog_aws_account_id
            input_database = var.cdh_input_database_name
        }
    )
}

resource "aws_iam_role_policy" "state-dataset-access" {
    name = "${var.lambda_function_name}-state-dataset-access"
    role = aws_iam_role.lambda.name
    policy = templatefile(
        "${path.module}/policies/state_dataset_access.json", {
            state_s3_bucket = var.cdh_state_s3_bucket 
        }
    )
}

resource "aws_iam_role_policy" "output-dataset-access" {
    name = "${var.lambda_function_name}-output-dataset-access"
    role = aws_iam_role.lambda.name
    policy = templatefile(
        "${path.module}/policies/output_dataset_access.json", {
            aws_account_id = var.aws_account_id
            input_s3_bucket = var.cdh_output_s3_bucket 
            input_kms_key_arn = var.cdh_output_s3_kms_key_arn
            input_catalog_aws_account_id = var.cdh_output_glue_catalog_aws_account_id
            input_database = var.cdh_output_database_name
        }
    )
}

resource "aws_iam_role_policy" "start-next-lambda" {
    name = "${var.lambda_function_name}-start-next-lambda"
    role = aws_iam_role.lambda.name
    count = var.start_next_lambda_arn ? 1 : 0 

    policy = templatefile(
        "${path.module}/policies/start_next_lambda.json", {
            start_next_lambda = var.start_next_lambda
        }
    )
}