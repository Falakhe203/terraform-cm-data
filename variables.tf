variable "aws_account_id" {
    description = "ID of the target account used for created terraform resources"
    type = string
}

variable "aws_tooling_account_id" {
    description = "ID of the master tooling used for shared resources"
    type = string
}

variable "aws_region" {
    description = "The aws region in which terraform resources will be deployed"
    type = string
}

variable "stage" {
    description = "Type of stage (dev, int, prod) used for the deployment and naming"
    type = string
}

variable "environment" {
    description = "Name of the specified subproject/environment"
    type = string
}

variable "cm_data_project" {
    description = "Name of the project"
    type = map(string)
}

variable "cm_data_prefix" {
    description = "The prefix for used resources in the project"
    type = string
}

variable "itsm_forwarder" {
    description = "Variables associated with the ITSM forwarder"
    type = map(any)
    default = {}
}

variable "log_retention" {
    description = "AWS Cloudwatch Logs retention in days"
    type = number
    default = 90
}

variable "enable_monitoring" {
    description = "Enable monitoring"
    type = bool
    default = false
}

variable "cm_data_source_layer" {
    description = "Variables associated with the otd_cm_data_src database"
    type = map(string)
}

variable "cm_master_data_prepared_layer" {
    description = "Variables associatd to the otd_cm_master_data_pre database"
    type = map(string)
}

variable "cm_master_data_sementic_layer" {
    description = "Variables associatd to the otd_cm_master_data_sem database"
    type = map(string)
}

variable "cm_transaction_data_prepared_layer" {
    description = "Variables associated to the otd_cm_transaction_data_pre database"
    type = map(string)
}

variable "cm_transaction_data_semantic_layer" {
    description = "Variables associated to the otd_cm_transaction_data_sem database"
    type = map(string)
}
variable "cm_raw_data_prepared_layer" {
    description = "Variables associated to the otd_cm_raw_data_pre database"
    type = map(string)
}