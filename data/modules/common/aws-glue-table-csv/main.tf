resource "aws_glue_catalog_table" "table" {
    name = var.table_name 
    database_name = var.database_name
    catalog_id = var.glue_catalog_aws_account_id
    table_type = "EXTERNAL TABLE"
    parameters = var.table_parameters
    owner = "owner"

    storage_descriptor {
      location = var.s3_storage_location
      input_format = "org.pache.hadoop.mapred.TextInputFormat"
      output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      parameters = var.table_parameters

    #   serialization with qoute support
        ser_de_info {
            serialization_library = var.serialization_library

            parameters = var.serialization_parameters
        }

        dynamic "columns" {
            for_each = var.columns
            content {
                name = columns.value[0]
                type = columns.value[1]
            }
        }
    }

    dynamic "partition_keys" {
        for_each = var.partition_keys
        content {
            name = partition_keys.value[0]
            type = partition_keys.value[1]
        }
    }

    lifecycle {
        #   these values are set by Glue Crawler and shouldn't be reset by terraform
        ignore_changes = [
            parameters["CrawlerSchemaDeserializerVersion"],
            parameters["CrawlerSchemaSerializerVersion"],
            parameters["averageRecordSize"],
            parameters["objectCount"],
            parameters["recordCount"],
            parameters["sizeKey"],
            parameters["UPDATED_BY_CRAWLER"],
            storage_descriptor.0.number_of_buckets,
            storage_descriptor.0.parameters["CrawlerSchemaDeserializerVersion"],
            storage_descriptor.0.parameters["CrawlerSchemaSerializerVersion"],
            storage_descriptor.0.parameters["averageRecordSize"],
            storage_descriptor.0.parameters["objectCount"],
            storage_descriptor.0.parameters["recordCount"],
            storage_descriptor.0.parameters["sizeKey"],
            storage_descriptor.0.parameters["UPDATED_BY_CRAWLER"],
        ]
    }
}
