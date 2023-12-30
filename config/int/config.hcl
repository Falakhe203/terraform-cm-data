locals {
    aws_tooling_account_id = "123729171657"

    enable_monitoring = false
    mft_connection_available = true

    cm_data_source_layer = {
        cdh_s3_bucket = "cdh-otd-cm-data-src-gpi3"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/3fe05b13-1e00-4086-96ec-c83730a1bea6"
        cdh_catalog_aws_account_id = "123917208335"
    }

    cm_master_data_prepared_layer = {
        cdh_s3_bucket = "cdh-otd-cm-master-data-pre-z7cx"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/3fe05b13-1e00-4086-96ec-c83730a1bea6"
        cdh_catalog_aws_account_id = "123917208335"
    }

    cm_master_data_semantic_layer = {
        cdh_s3_bucket = "cdh-otd-cm-master-data-sem-7d5o"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/3fe05b13-1e00-4086-96ec-c83730a1bea6"
        cdh_catalog_aws_account_id = "123917208335"
    }

    cm_transaction_data_prepared layer = { 
        cdh_s3_bucket = "cdh-otd-cm-transaction-data-pre-yktr"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/3fe05b13-1e00-4086-96ec-c83730a1bea6"
        cdh_catalog_aws_account_id = "123917208335"
    }

    cm_transaction_data_semantic layer = { 
        cdh_s3_bucket = "cdh-otd-cm-transaction-data-sem-ftnf"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/3fe05b13-1e00-4086-96ec-c83730a1bea6"
        cdh_catalog_aws_account_id = "123917208335"
    }

    cm_raw_data_prepared layer = { 
        cdh_s3_bucket = "cdh-otd-cm-transaction-data-pre-1qta"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/3fe05b13-1e00-4086-96ec-c83730a1bea6"
        cdh_catalog_aws_account_id = "123917208335"
    }
}
