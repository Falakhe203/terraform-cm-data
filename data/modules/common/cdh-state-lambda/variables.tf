variable "aws_account_id" {
    description = "Id of the target account used for created terraform resources"
    type = "string"
}

variable "lambda_function_name" {
    description = "Name of AWS Lambda function"
    type = string
}    

variable "lambda_handler" {
    description = "Function path to AWS Lambda Handler function"
    type = string
} 

variable "lambda_layers" {
    description = "AWS Lambda layers to attach to Lambda function"
    type = list(string)
    default = []
} 

variable "lambda_inputs" {
    description = "Environment variables to set for Lambda function"
    type = map(string)
} 

variable "lambda_memory" {
    description = "Memory limit for Lambda function"
    type = string
    default = "128"
} 

variable "lambda_runtime" {
    description = "Runtime for Lambda function"
    type = string
    default = "Python3.9"
} 

variable "cdh_input_s3_bucket" {
    description = "AWS S3 bucket with source data"
    type = string
} 

variable "cdh_input_s3_kms_key_arn" {
    description = "AWS KMS ARN key with which data in source s3 is encrypted"
    type = string
} 

variable "cdh_input_glue_catalog_aws_account_id" {
    description = "AWS Glue Catalog account id / catalog id for source database"
    type = string
} 

variable "cdh_input_database_name" {
    description = "AWS Glue Catalog database name"
    type = string
} 

variable "cdh_output_s3_bucket" {
    description = "AWS S3 bucket with target data"
    type = string
} 

variable "cdh_output_s3_kms_key_arn" {
    description = "AWS KMS key for s3 encryption in output bucket"
    type = string
} 

variable "cdh_output_glue_catalog_aws_account_id" {
    description = "AWS Glue Catalog account id / catalog id for output database"
    type = string
} 

variable "cdh_output_database_name" {
    description = "Name of database with source data"
    type = string
} 

variable "cdh_output_database_name" {
    description = "AWS Glue Catalog Database name for target database"
    type = string
} 

variable "start_next_lambda_arn" {
    description = "Lambda function ARN to trigger on success"
    type = string
} 

variable "lambda_code_path" {
    description = "Local path to directory with Python files"
    type = string
} 

variable "log_retention" {
    description = "AWS Cloudwatch Logs retention in days"
    type = number
    default = 366
}

variable "lambda_timeout" {
    description = "Maximum runtime for Lambda function in seconds"
    type = number
    default = 60
}

variable "sns_alert_topic" {
    description = "The SNS topic to deliver alerts to"
    type = string
    default = null
}

variable "start_next_lambda" {
    description = "Enable triggering other lambda on success"
    type = bool
    default = false
}

variable "cdh_state_s3_bucket" {
    description = "AWS S3 bucket for state files"
    type = string
}

