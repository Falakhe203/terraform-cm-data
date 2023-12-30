module "prepared-layer-booking-state-lambda" {
    source = "../../../../modules/common/cdh-state-lambda"

    lambda_function_name = "${var.cm_data_prefix}-prepared-layer-booking-state-${var.stage}"
    aws_account_id = var.aws_account_id
    lambda_code_path = "${path.module}/python_logic"
    lambda_handler = "src_prepared_layer_lambda_handler.lambda_handler"
    lambda_memory = 512
    lambda_timeout = 60
    lambda_runtime = "python3.9"
    lambda_layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSDataWrangler-Python39:7"]
    log_retention = var.log_retention
    sns_alert_topic = var.sns_alert_topic

    lambda_inputs = {
        CDH_PREPARED_S3_STATE_BUCKET = var.state_bucket_id
        CDH_PREPARED_S3_OUTPUT_PATH = "s3://${var.cdh_prepared_s3_bucket}/booking state/"
    }

    cdh_input_database_name = "otd_cm_data_src"
    cdh_input_s3_bucket = var.cdh_source_s3_bucket
    cdh_input_catalog_aws_account_id = var.cdh_source_catalog_aws_account_id 
    cdh_input_s3_kms_key_arn = var.cdh_source_s3_kms_key_arn   

    cdh_state_s3_bucket = var.state_bucket_id

    cdh_output_database_name = "otd_cm_master_data_pre"
    cdh_output_s3_bucket = var.cdh_prepared_s3_bucket
    cdh_output_catalog_aws_account_id = var.cdh_prepared_catalog_aws_account_id
    cdh_output_s3_kms_key_arn = var.cdh_prepared_s3_kms_key_arn

    start_next_lambda = true
    start_next_lambda_arn = var.next_lambda_arn
}

resource "aws_glue_catalog_table" "prepared-layer-table" {
    name = "booking_state"
    database_name = "otd_cm_master_data_pre"
    catalog_id = var.cdh_prepared_catalog_aws_account_id
    table_type = "EXTERNAL_TABLE"

    storage_descriptor {}

    # lifecyle {
    #     ignore_changes = [storage_descriptor, parameters]
    # }
    lifecycle { 
        ignore_changes = var.list_with_changes_to_ignore
        prevent_destroy = local.destroy
}
}

resource "aws_cloudwatch_event_rule" "trigger-source-to-prepared" {
    name = "${var.cm_data_prefix}-booking-state-trigger-source-to-prepared-${var.stage}"

    event_pattern = jsonencode({
        source = ["aws.glue"]
        detail-type = ["Glue Crawler State Change"]
        detail = {
            crawlerName = [var.source_layer_crawler_name]
            state = ["Succeeded"]
        }
    })
}

resource "aws_cloudwatch_event_target" "prepared-layer-lambda" {
    rule = aws_cloudwatch_event_rule.trigger-source-to-prepared.name 
    arn = module.prepared-layer-booking-state-lambda.lambda_function_arn
}

resource "aws_lambda_permission" "prepared-layer-lambda-eventbridge" {
    statement_id = aws_cloudwatch_event_rule.trigger-source-to-prepared.name
    action = "lambda:InvokeFunction"
    function_name =  module.prepared-layer-booking-state-lambda.lambda_function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.trigger-source-to-prepared.arn
}
