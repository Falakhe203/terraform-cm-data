resource "aws_glue_crawler" "crawler" {
    name = var.glue_crawler_name
    database_name = var.cdh_glue_database_name
    role = aws_iam_role.glue-crawler.name
    security_configuration = aws_glue_security_configuration.crawler.name

    s3_target {
      path = "s3://${var.cdh_s3_ingest_bucket}/${var.cdh_s3_ingest_path}/"

    }

    # prevent Crawler from overriding parameters set by Terraform
    configuration = jsondecode({
        Version = 1
        CrawlerOutput = {
            Tables = { AddOrUpdateBehavior = var.crawler_schema_update_behavior }
        }
    })

    schema_change_policy {
      delete_behavior = "LOG"
    }
}

resource "aws_glue_security_configuration" "crawler" {
    name = "${var.glue_crawler_name}-security-config"

    encryption_configuration {
    #   checkov:skip=CKV_AWS_99:Cloudwatch/Job bookmark encryption has to be decided on
        cloudwatch_encryption {
          cloudwatch_encryption_mode = "DISABLED"
        }

        job_bookmarks_encryption {
          job_bookmarks_encryption_mode = "DISABLED"
        }

        s3_encryption {
          s3_encryption_mode = "SSE-KMS"
          kms_key_arn =  var.cdh_s3_ingest_kms_key_arn
        }
    }
}