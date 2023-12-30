module "source-layer-booking-state" {
    source = "../../../../modules/common/aws-glue-table-csv"
    table_name = "booking-state"
    database = "otd_cm_data_src"
    glue_catalog_aws_account_id = var.cdh_source_catalog_aws_account_id
    s3_storage_location = "s3://${var.cdh_source_s3_bucket}/data/booking-state/"
    serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    serialization_parameters = {
        "field.delim" = ";"
    }
    table_parameters = {
        "delimeter" = ";",
        "skip.header.line.count" = 1,
        "classification" = "csv"
        "compressionType" = "none"
        "areColumnsQuoted" = true
    }

    columns = [
        [ "ID", "string"],
        ["IDINTERNAL", "string"], 
        ["STATE", "string"],
        ["EVENTDATE", "string"],
        ["EVENTTIME", "string"],
        ["USER", "string"],
        ["DELETED", "string"],
    ]

    partition_keys = [
        ["year", "string"],
        ["month", "string"],
        ["day", "string"] 
    ]
}
