variable "aws_account_id" {
    description = "ID of the target account used for created terraform resources"
    type = string
}

variable "cm_data_prefix" {
    description = "The prefix for used resources in the project"
    type = string
}