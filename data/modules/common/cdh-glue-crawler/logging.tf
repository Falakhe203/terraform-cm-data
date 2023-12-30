resource "aws_cloudwatch_log_group" "crawler" {
    name = "/aws-glue/crawlers-role/${aws_iam_role.glue-crawler.name}-${aws_glue_security_configuration.crawler.name}"
    retention_in_days = var.log_retention
    # checkov:skip=CKV_AWS_158: Log retention has to be decided
}