variable "aws_account_id" {
    description = "Id of the target account used for created terraform resources"
    type = "string"
}

variable "aws_region" {
    description = "The aws region in which terraform resources will be deployed"
    type = string
}    