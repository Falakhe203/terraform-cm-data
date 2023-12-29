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

variable "cm_data_prefix" {
    description = "The prefix for used resources in the project"
    type = string
}

variable "mft_connection_available" {
    description = "Variable describing whether Managed File Transfer (MFT) connection is available"
    type = bool
    default = false
}

variable "cm_data_source_layer" {
    description = "Variables associated to the otd_cm_data_src database"
    type = map(string)
}