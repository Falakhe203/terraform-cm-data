variable "aws_account_id" {
    description = "ID of the target account used for created terraform resources"
    type = string
}

variable "glue_crawler_name" {
    description = "Name of AWS Glue Crawler"
    type = string
}

variable "cdh_s3_ingest_bucket" {
    description = "AWS s3 bucket with ingested data"
    type = string
}

variable "cdh_s3_ingest_kms_key_arn" {
    description = "AWS KMS key for s3 encryption in ingest bucket"
    type = string
}

variable "cdh_s3_ingest_path" {
    description = "Path to data inside ingest_s3_bucket"
}

variable "cdh_glue_database_name" {
    description = "AWS Glue Catalog Database name where Crawler will update tables"
    type = string
}

variable "cdh_glue_catalog_aws_account_id" {
    description = "AWS Glue Catalog account id / catalog id for database"
    type = string
}

variable "crawler_schema_update_behavior" {
    description = "AWS Glue crawler behavior on schema change"
    type = string
    default = "MergeNewColumns"
}

variable "log_retention" {
    description = "Log retention in days"
    type = string
    default = "90"
}

variable "sns_alert_topic" {
    description = "The SNS topic to deliver alerts to"
    type = string
    default = "null"
}