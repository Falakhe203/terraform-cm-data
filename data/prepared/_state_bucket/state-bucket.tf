data "aws_region" "current" {}

module "s3-bucket-state" {
    source = "https://github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v3.3.0"

    bucket = "${var.cm_data_prefix}-prepared-layer-state-${var.aws_account_id}-${data.aws_region.current.name}"
    acl = "private"

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

    server_side_encryption_configuration = { 
        rule = {
            apply_server_side_encryption_by_default = {
                sse_algorithe = "aws:kms"
            }     
        }
    }
}