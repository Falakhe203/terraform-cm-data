locals {
    stage = get_env("TF_VAR_STAGE", "dev")


    common_vars = read_terragrunt_config("../config/common/config.hcl")
    stage_vars = read_terragrunt_config("../config/${local.stage}/config.hcl")

    aws_account_id = local.stage_vars.locals.aws_account_id
    aws_region = local.common_vars.locals.aws_region
    aws_tooling_account_id = local.common_vars.locals.aws_tooling_account_id

    environment = local.common_vars.locals.environment

    mft_connection_available = local.stage_vars.locals.mft_connection_available
    cm_data_source_layer = local.common_vars.locals.cm_data_source_layer

    cm_data_project = local.common_vars.locals.cm_data_project
    cm_data_prefix = local.common_vars.locals.cm_data_prefix
}

inputs = {
    aws_account_id = local.aws_account_id
    aws_region = local.aws_region
    aws_tooling_account_id = local.aws_tooling_account_id
    stage = local.stage
    cm_data_prefix = local.cm_data_prefix
    mft_connection_available = local.mft_connection_available
    cm_data_source_layer = local.var_cm_data_source_layer
}

generate "provider" {
    path = "provider.tf"
    if_exist = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region = "${local.aws_region}"
    allowed_account_ids = ["${local.aws_account_id}"]

    profile = "${local.cm_data_prefix}-provider-${local.stage}"

    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
    skip_region_validation = true
    skip_credentials_validation = true

    default_tags {
        tags = {
            Project = "${local.cm_data_project}"
            Environment = "${local.environment}"
            Stage = "${local.stage}"
            Type = "Terraform"
        }
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
EOF
}

remote_state {
    backend = "s3"
    config = {
        encrypt = true
        bucket = "cm-data-${local.aws_tooling_account_id}-${local.aws_region}-terraform"
        key = "${path_relative_to_include()}/${local.environment}-${local.stage}/bootstrap.tfstate"
        region = local.aws_region
        dynamodb_table = "cm-data-${local.aws_tooling_account_id}-${local.aws_region}-terraform"
        s3_bucket_tags = {
            Project = local.cm_data_project
            Environment = local.environment
            Stage = local.stage
            Type = "Terraform"            
        }
        dynamodb_table_tags = {
            Project = local.cm_data_project
            Environment = local.environment
            Stage = local.stage
            Type = "Terraform"
        }   
    }
    generate = {
        path = "state.tf"
        if_exists = "overwrite_terragrunt"
    }
}
