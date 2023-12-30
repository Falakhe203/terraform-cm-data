variable "cdh_source_s3_bucket" {
    description = "Source Layer: s3 bucket with ingest data"
    type = "string"
}

variable "cdh_source_catalog_aws_account_id" {
    description = "Source Layer:AWS Glue Catalog account id/catalog id for database"
    type = "string"
}
