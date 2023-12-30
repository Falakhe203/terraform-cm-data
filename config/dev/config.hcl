locals {
    aws_tooling_account_id = "123456689035"

    enable_monitoring = false
    mft_connection_available = false

    cm_data_source_layer = {
        cdh_s3_bucket = "cdh-otd-cm-data-src-jski"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/a3c4ee32-c6ec-4375-bfdi-Sf17ea1dc25a"
        cdh_catalog_aws_account_id = "123490910106"
    }

    cm_master_data_prepared_layer = {
        cdh_s3_bucket = "cdh-otd-cm-master-data-pre-ojk2"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/a3c4ee32-c6ec-4a75-bfdi-5f17ea1dc2Sa"
        cdh_catalog_aws_account_id = "1234567357812"
    }

    cm_master_data_semantic_layer = {
        cdh_s3_bucket = "cdh-otd-cm-master-data-sen-8mas"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/a3c4ee32-c6ec-4a75-bfdi-5f17ea1dc2Sa"
        cdh_catalog_aws_account_id = "123290010106"
    }

    cm_transaction_data_prepared layer = { 
        cdh_s3_bucket = "cdh-otd-cm-transaction-data-pre-4kyo"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/a3c4ee32-c6ec-4a75-bfdi-sf17ea1dc25a"
        cdh_catalog_aws_account_id = "123290010106"
    }

    cm_transaction_data_semantic layer = { 
        cdh_s3_bucket = "cdh-otd-cm-transaction-data-sem-esu6"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/a3c4ee32-c6ec-4a75-bfdi-sf17ea1dc25a"
        cdh_catalog_aws_account_id = "123290010106"
    }

    cm_raw_data_prepared layer = { 
        cdh_s3_bucket = "cdh-otd-cm-transaction-data-pre-wvzg"
        cdh_s3_kms_key_arn = "arn:aws:kms:eu-west-1:468747793086:key/a3c4ee32-c6ec-4a75-bfdi-sf17ea1dc25a"
        cdh_catalog_aws_account_id = "123290010106"
    }
}
