resource "aws_cloudwatch_metric_alarm" "glue_crash_alert" {
    count = coalesce(var.sns_alert_topic, false) ? 1 : 0

    alarm_name = "${var.glue_crawler_name}-glue-alert"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "glue.driver.aggregate.numFailedTasks"
    namespace = "AWS/Glue"
    period = 1 * 60 * 60 # one hour
    statistic = "Sum"
    threshold = "1"
    alarm_description = "This metric monitors glue errors"

    insufficient_data_actions = [
    ]

    alarm_actions = [
        "${var.sns_alert_topic}",
    ]

    ok_actions = [
    ]

    dimensions = {
      JobName = "${var.glue_crawler_name}"
      JobRunId = "ALL"
    }
}