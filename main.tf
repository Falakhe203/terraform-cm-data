module "athena-result-bucket" {
    source = "./modules/athena-result-bucket"

    aws_account_id = var.aws_account_id
    aws_region = var.aws_region
}

module "itsm_forwarder" {
    source = "./modules/itsm-forwarder"

    count = var.enable_monitoring ? 1 : 0

    aws_account_id = var.aws_account_id
    stage = var.stage

    lambda_function_name = var.itsm_forwarder.lambda_function_name
    lambda_layers = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSDataWranger-Python39:7"]

    lambda_inputs = {
        STAGE = var.stage
        ACCOUNT_ID = var.aws_account_id
        REGION = var.aws_region
        ITSM_API_URL = var.itsm_forwarder.itsm_api_url
        TEAMS_WEBHOOK_URL = var.itsm_forwarder.TEAMS_WEBHOOK_URL
        MAX_ITEMS_SIZE = var.itsm_forwarder.teams_webhook_url
    }
}

#  /"Source layer infrastructure"/

module "source-layer-cm-data-glue-crawler" {
    source = "./data/source/otd_cm_data_src/_crawler"

    aws_account_id = var.aws_account_id
    stage = var.stage
    cm_data_prefix = var.cm_data_prefix

    cdh_source_database = "otd_cm_data_src"
    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_s3_kms_key_arn = var.cm_data_source_layer.cdh_s3_kms_key_arn
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id

    sns_alert_topic = var.enable_monitoring ? module.itsm-forwarder.sns_topic_arn : null
}

module "booking-source-layer" {
    source = "./data/source/otd_cm_data_src/booking_state"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "acc-mapping-source-layer" {
    source = "./data/source/otd_cm_data_src/acc_mapping"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "account-source-layer" {
    source = "./data/source/otd_cm_data_src/account"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "automatic-orders-source-layer" {
    source = "./data/source/otd_cm_data_src/automatic_orders"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "order-source-layer" {
    source = "./data/source/otd_cm_data_src/order"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "order-addition-source-layer" {
    source = "./data/source/otd_cm_data_src/order_addition"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "order-detail-source-layer" {
    source = "./data/source/otd_cm_data_src/order_detail"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "order-detail-addition-source-layer" {
    source = "./data/source/otd_cm_data_src/order_detail_addition"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "order-detail-state-source-layer" {
    source = "./data/source/otd_cm_data_src/order_detail_state"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

module "order-state-source-layer" {
    source = "./data/source/otd_cm_data_src/order_state"

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id
}

# "Prepared layer infrastructure"

# "Common state bucket for delta load"

module "prepared-layer-state-bucket" {
    source = "./data/prepared/_state_bucket"

    aws_account_id = var.aws_account_id
    cm_data_prefix = var.cm_data_prefix
}

# "tables stored in database "otd_cm_master_data_pre"

module "accounts-prepared-layer" {
    source = "./data/prepared/otd_cm_master_data_pre/accounts"

    aws_account_id = var.aws_account_id
    stage = var.stage
    cm_data_prefix = var.cm_data_prefix
    source_layer_crawler = module.source-layer-cm-data-glue-crawler.glue_crawler_name
    state_bucket_id = module.prepared-layer-state-bucket.bucket_id
    sns_alert_topic = var.enable_monitoring ? module.itsm-forwarder.sns_topic : null
    next_lambda_arn = module.automatic-orders-prepared-layer.automatic-orders-prepared-layer-lambda-arn

    depends_on = [module.automatic-orders-prepared-layer]

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_s3_kms_key_arn = var.cm_data_source_layer.cdh_s3_kms_key_arn
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id

    cdh_prepared_s3_bucket = var.cm_master_data_prepared_layer.cdh_s3_bucket
    cdh_prepared_s3_kms_key_arn = var.cm_master_data_prepared_layer.cdh_s3_kms_key_arn
    cdh_prepared_catalog_aws_account_id = var.cm_transaction_data_prepared_layer.cdh_catalog_aws_account_id      

}

module "account-mappings-prepared-layer" {
    source = "./data/prepared/otd_cm_master_data_pre/account_mappings"
    
    aws_account_id = var.aws_account_id
    stage = var.stage
    cm_data_prefix = var.cm_data_prefix
    source_layer_crawler = module.source-layer-cm-data-glue-crawler.glue_crawler_name
    state_bucket_id = module.prepared-layer-state-bucket.bucket_id
    sns_alert_topic = var.enable_monitoring ? module.itsm-forwarder.sns_topic : null
    next_lambda_arn = module.account_mappings-semantic-layer.account_mappings-semantic-layer-lambda-arn

    depends_on = [module.account_mappings-semantic-layer]

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_s3_kms_key_arn = var.cm_data_source_layer.cdh_s3_kms_key_arn
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id

    cdh_prepared_s3_bucket = var.cm_master_data_prepared_layer.cdh_s3_bucket
    cdh_prepared_s3_kms_key_arn = var.cm_data_prepared_layer.cdh_s3_kms_key_arn
    cdh_sprepared_catalog_aws_account_id = var.cm_data_prepared_layer.cdh_catalog_aws_account_id    
}

# tables stored in database "otd_cm_transaction_data_pre"

module "automatic-order-prepared-layer" {
    source = "./data/prepared/otd_cm_transaction_data_pre/automatic_orders"
    
    aws_account_id = var.aws_account_id
    stage = var.stage
    cm_data_prefix = var.cm_data_prefix
    state_bucket_id = module.prepared-layer-state-bucket.bucket_id
    sns_alert_topic = var.enable_monitoring ? module.itsm-forwarder.sns_topic : null

    source_layer_crawler = module.source-layer-cm-data-glue-crawler.glue_crawler_name
    next_lambda_arn = module.automatic-orders-optimized-semantic-layer.automatic-orders-optimized-semantic-layer-lambda-arn

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_s3_kms_key_arn = var.cm_data_source_layer.cdh_s3_kms_key_arn
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id 

    depends_on = [module.automatic-orders-optimized-semantic-layer]

    cdh_prepared_s3_bucket = var.cm_transaction_data_prepared_layer.cdh_s3_bucket
    cdh_prepared_s3_kms_key_arn = var.cm_transaction_data_prepared_layer.cdh_s3_kms_key_arn
    cdh_prepared_catalog_aws_account_id = var.cm_transaction_data_prepared_layer.cdh_catalog_aws_account_id    
}

module "bookings-raw-prepared-layer" {
    source = "./data/prepared/otd_cm_raw_data_pre/bookings_raw"

    stage = var.stage
    cm_data_prefix = var.cm_data_prefix
    state_bucket_id = module.prepared-layer-state-bucket.bucket_id
    sns_alert_topic = var.enable_monitoring ? module.itsm-forwarder.sns_topic : null

    source_layer_crawler = module.source-layer-cm-data-glue-crawler.glue_crawler_name

    cdh_source_s3_bucket = var.cm_data_source_layer.cdh_s3_bucket
    cdh_source_s3_kms_key_arn = var.cm_data_source_layer.cdh_s3_kms_key_arn
    cdh_source_catalog_aws_account_id = var.cm_data_source_layer.cdh_catalog_aws_account_id 

    cdh_prepared_s3_bucket = var.cm_raw_data_prepared_layer.cdh_s3_bucket
    cdh_prepared_s3_kms_key_arn = var.cm_raw_data_prepared_layer.cdh_s3_kms_key_arn
    cdh_prepared_catalog_aws_account_id = var.cm_raw_data_prepared_layer.cdh_catalog_aws_account_id 
}

# Semantic layer infrastructure 
# tables stored in database "otd_cm_transaction_data_sem"

module "automatic-orders-optimized-semantic-layer" {
    source = "./data/prepared/otd_cm_transaction_data_sem/automatic_orders_optimized"

    aws_account_id = var.aws_account_id
    stage = var.stage
    cm_data_prefix = var.cm_data_prefix
    source_layer_crawler = module.source-layer-cm-data-glue-crawler.glue_crawler_name
    state_bucket_id = module.prepared-layer-state-bucket.bucket_id
    sns_alert_topic = var.enable_monitoring ? module.itsm-forwarder.sns_topic : null
    next_lambda_arn = module.automatic-orders-semantic-layer.automatic-orders-semantic-layer-lambda-arn

    depends_on = [module.automatic-orders-prepared-layer]

    cdh_prepared_s3_bucket = var.cm_transaction_data_prepared_layer.cdh_s3_bucket
    cdh_prepared_s3_kms_key_arn = var.cm_transaction_data_prepared_layer.cdh_s3_kms_key_arn
    cdh_prepared_catalog_aws_account_id = var.cm_transaction_data_prepared_layer.cdh_catalog_aws_account_id

    cdh_prepared2_s3_bucket = var.cm_transaction_data_prepared_layer.cdh_s3_bucket
    cdh_prepared2_s3_kms_key_arn = var.cm_transaction_data_prepared_layer.cdh_s3_kms_key_arn
    cdh_prepared2_catalog_aws_account_id = var.cm_transaction_data_prepared_layer.cdh_catalog_aws_account_id

    cdh_semantic_s3_bucket = var.cm_transaction_data_semantic_layer.cdh_s3_bucket
    cdh_semantic_s3_kms_key_arn = var.m_transaction_data_semantic_layer.cdh_s3_kms_key_arn
    cdh_semantic_catalog_aws_account_id = var.m_transaction_data_semantic_layer.cdh_catalog_aws_account_id      

}

module "orders-cms-semantic-layer" {
    source = "./data/prepared/otd_cm_transaction_data_sem/order_cms"

    aws_account_id = var.aws_account_id
    stage = var.stage
    cm_data_prefix = var.cm_data_prefix
    sns_alert_topic = var.enable_monitoring ? module.itsm-forwarder.sns_topic : null

    cdh_prepared_s3_bucket = var.cm_master_data_prepared_layer.cdh_s3_bucket
    cdh_prepared_s3_kms_key_arn = var.cm_master_data_prepared_layer.cdh_s3_kms_key_arn
    cdh_prepared_catalog_aws_account_id = var.cm_transaction_data_prepared_layer.cdh_catalog_aws_account_id   
 
    cdh_semantic_s3_bucket = var.cm_master_data_semantic_layer.cdh_s3_bucket
    cdh_semantic_s3_kms_key_arn = var.cm_master_data_semantic_layer.cdh_s3_kms_key_arn
    cdh_semantic_catalog_aws_account_id = var.cm_master_data_semantic_layer.cdh_catalog_aws_account_id
}
