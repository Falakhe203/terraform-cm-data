terraform {
    backend "s3" {
        bucket = "cm-data-123615497782-eu-west-1-terraform"
        dynamodb_table = "cm-data-123615497782-eu-west-1-terraform"
        encrypt = true
        key = "./cm-data-provider-dev/state.tfstate"
        region = "eu-west-1"
    }
}