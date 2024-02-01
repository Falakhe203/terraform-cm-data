variable "table_name" {
    description = "name of Glue Data Catalog table to be created"
    type = string
}

variable "database_name" {
    description = "name of Glue Data Catalog database for table"
    type = string
}

variable "glue_catalog_aws_account_id" {
    description = "AWS account id of the Glue Data Catalog"
    type = string
}

variable "s3_storage_location" {
    description = "s3 path to source data"
    type = string
}

variable "columns" {
    description = "list of table columns in [name, type] tuples"
    type = list(list(string))
    default = []
}

variable "partition_keys" {
    description = "list of table pertition in [name, type] tuples"
    type = list(list(string))
    default = []
}

variable "table_parameters" {
    description = "Parameters for Glue Data Catalog table"
    type = map(any)
    default = {
        areColumnsQuoted = "false"
        classification = "csv"
        columnsOrdered = "true"
        compressionType = "none"
        delimeter = ","
        typeofData = "file"
        "skip.header.line.count" = 1
    }
}

variable "serialization_library" {
    description = "Glue Data Catalog serialization library"
    type = string
    default = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
}

variable "serialization_parameters" {
    description = "Parameters for serialization library"
    type = map(string)
    default = {
        escapeChar = "\\"
        quoteChar = "\""
        seperatorChar = ","
    }
}
