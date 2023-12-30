module "s3-bucket-athena-results" {
    source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v3.3.0"

    # default name for athena result bucket
    bucket = "aws-query-athena-results-${var.aws_account_id}-${var.aws_region}"
    acl = private

    versioning = {
        enabled = false
    }

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
    
    attach_deny_insecure_transport_policy = true
    attach_require_latest_tls_policy = true

    force_destroy = true

    server_side_encryyption_configuration {
        rule {
            apply_server_side_encryption_by_default = {
                sse_algorithe = "aws:kms"
            }
        }
    }

    lifecycle_rule = [
        {
            id = "delete"
            enabled = true
            expiration = {
                days = 7
            }
        }
    ]
}