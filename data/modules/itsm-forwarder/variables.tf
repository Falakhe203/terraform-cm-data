variable "aws_account_id" {
    description = "Id of the target account used for created terraform resources"
    type = "string"
}

variable "lambda_function_name" {
    description = "Name of AWS Lambda function"
    type = string
}    

variable "lambda_layers" {
    description = "AWS Lambda layers to attach to Lambda function"
    type = list(string)
    default = []
} 

variable "lambda_inputs" {
    description = "Environment variables to set for Lambda function"
    type = map(string)
} 

variable "lambda_memory" {
    description = "Memory limit for Lambda function"
    type = string
    default = "128"
} 

variable "lambda_runtime" {
    description = "Runtime for Lambda function"
    type = string
    default = "Python3.9"
} 

variable "log_retention" {
    description = "AWS Cloudwatch Logs retention in days"
    type = number
    default = 366
}

variable "lambda_timeout" {
    description = "Maximum runtime for Lambda function in seconds"
    type = number
    default = 60
}

variable "stage" {
    description = "The stage (dev, int, prod) the resources run in"
    type = string
}