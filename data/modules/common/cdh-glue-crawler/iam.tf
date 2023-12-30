resource "aws_iam_role" "glue-crawler" {
  name = "${var.glue_crawler_name}-role"
  assume_role_policy = file("${path.module}/policies/glue_crawler_assume_role_policy.json")
}

resource "aws_iam_role_policy" "logging" {
    name = "${var.glue_crawler_name}-logging"
    role = aws_iam_role.glue-crawler.name
    policy = templatefile(
        "${path.module}/policies/glue_crawler_logging.json", {
        loggroup = aws_cloudwatch_log_group.crawler.name
        }
    )
}

resource "aws_iam_role_policy" "source-dataset-access" {
    name = "${var.glue_crawler_name}-source-dataset-access"
    role = aws_iam_role.glue-crawler.name
    policy = templatefile(
        "${path.module}/policies/source_access.json", {
            aws_account_id = var.aws_account_id
            ingest_s3_bucket = var.cdh_s3_ingest_bucket
            ingest_s3_kms_key_arn = var.cdh_s3_ingest_kms_key_arn
            glue_dataset_name = var.cdh_glue_database_name
            glue_catalog_aws_account_id = var.cdh_glue_catalog_aws_account_id
        }
    )
}

resource "aws_iam_role_policy" "glue-security-config" {
    name = "${var.glue_crawler_name}-glue-security-config-access"
    role = aws_iam_role.glue-crawler.name
    policy = file("${path.module}/policies/glue_crawler_security_config_access.json")
}