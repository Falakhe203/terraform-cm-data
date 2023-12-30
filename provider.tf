provider "aws" {
    region = "eu-west-1"
    allowed_account_ids = ["12330326035"]

    skip_region_validation = true
    skip_credentials_validation = true

    default_tags {
        tags = {
            Project = "ITLBHM"
            Environment = "cm-data-provider"
            Stage = "dev"
            Type = "Terraform"
        }
    }
    assume_role {
        role_arn = "aw:siam::123930326035;role/cm-data-cross.account_deplovment.role"
    }
}

terraform {
    required_version = ">= 1.2.3"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.19"
        }
    }
}

