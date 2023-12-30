variable "aws_account_id" {
    description = "Id of the target account used for created terraform resources"
    type = string
}

variable "stage" {
    description = "Type of stage (dev, int, prod) used for the deployment and naming"
    type = string
}

variable "cm_data_prefix" {
    description = "The prefix for used resources in the project"
    type = string
}

variable "log_retention" {
    description = "AWS Cloudwatch Logs retention in days"
    type = number
    default = 366
}

variable "sns_alert_topic" {
    description = "SNS topic to send alerts to"
    type = string
    default = null
}

variable "source_layer_crawler_name" {
    description = "Name of the Source Layer Glue Crawler"
    type = string
}

variable "state_bucket_id" {
    description = "ID of the state bucket for delta load"
    type = string
}

variable "next_lambda_arn" {
    description = "Name of the next lambda function"
    type = string
}

variable "cdh_source_s3_bucket" {
    description = "Source Layer: S3 bucket with ingest data"
    type = string
}

variable "cdh_source_s3_kms_key_arn" {
    description = "Source Layer: AWS kms key ARN for ingest S3 bucket"
    type = string
}

variable "cdh_source_catalog_aws_account_id" {
    description = "Source Layer: AWS Glue account id/catalog id for database"
    type = string
} 

variable "cdh_prepared_s3_bucket" {
    description = "Prepared Layer: S3 bucket name for prepared layer datastore"
    type = string
}

variable "cdh_prepared_s3_kms_key_arn" {
    description = "Prepared Layer: AWS kms key ARN for prepared layer encryption"
    type = string
}

variable "cdh_prepared_catalog_aws_account_id" {
    description = "Prepared Layer: AWS Glue account id/catalog id for database"
    type = string
} 
