locals {
    metrics_pattern = "[report_name=\"REPORT\", request_id_name=\"RequestId:\", request_id_value, duration_name=\"Duration:\", duration_va]ue]"
    cloudwatch_log_group_name = "/aws/lambda/${var.lambda_function_name}"
    namespace = "BMW/Lambda"
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration_alert" {
    count = coalesce(var.sns_alert_topic, false) ? 1 : 0

    alarm_name = "${var.lambda_function_name}-duration-alert"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "Duration"
    namespace = "AWS/Lambda"
    period = 1 * 60 * 60 # one hour
    statistic = "Maximum"
    threshold = var.lambda_timeout * 1000 * 0.8
    alarm_description = "This metric monitors lambda execution time"
    
    insufficient_data_actions = [
    ]

    alarm_actions = [
        "${var.sns_alert_topic}",
    ]
    
    ok_actions = [
    ]

    dimensions = {
      Function_name = "${var.lambda_function_name}"
      Resource = "${var.lambda_function_name}"
    }
}

resource "aws_cloudwatch_metric_alarm" "alarm_crash_alert" {
    count = coalesce(var.sns_alert_topic, false) ? 1 : 0

    alarm_name = "${var.lambda_function_name}-crash-alert"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "Errors"
    namespace = "AWS/Lambda"
    period = 1 * 60 * 60 # one hour
    statistic = "Maximum"
    threshold = var.lambda_timeout * 1000 * 0.8
    alarm_description = "This metric monitors lambda errors"
    
    insufficient_data_actions = [
    ]

    alarm_actions = [
        "${var.sns_alert_topic}",
    ]
    
    ok_actions = [
    ]

    dimensions = {
      Function_name = "${var.lambda_function_name}"
      Resource = "${var.lambda_function_name}"
    }    
}

resource "aws_cloudwatch_log_metric_filter" "calculator-memory-used" {
    count = coalesce(var.sns_alert_topic, false) ? 1 : 0

    name = "${var.lambda_function_name}-memory-used"
    log_group_name = local.cloudwatch_log_group_name

    pattern = local.metrics_pattern
    
    metric_transformation {
      name = "MemoryUsed-${var.lambda_function_name}"
      namespace = local.namespace
      value = "max_memory_used_value"
    }
}

resource "aws_cloudwatch_log_metric_filter" "calculator-memory-size" {
    count = coalesce(var.sns_alert_topic, false) ? 1 : 0

    name = "${var.lambda_function_name}-memory-size"
    log_group_name = local.cloudwatch_log_group_name

    pattern = local.metrics_pattern
    
    metric_transformation {
      name = "MemoryUsed-${var.lambda_function_name}"
      namespace = local.namespace
      value = "memory_size_value"
    }
}

resource "aws_cloudwatch_metric_alarm" "calculator_memory_alarm" {
  count = coalesce(var.sns_alert_topic, false) ? 1 : 0

  alarm_name                = "${var.lambda_function_name}-memory-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  threshold                 = 80
  alarm_description         = "Request error rate has exceeded 80%"
  insufficient_data_actions = []

  alarm_actions = [
        "${var.sns_alert_topic}"
    ]

  metric_query {
    id          = "e1"
    expression  = "(m2/m1)*100"
    label       = "MemoryUsedPercent"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "MemorySize-${var_lambda_function_name}"
      namespace   = local.namespace
      period      = 1 * 60 * 60
      stat        = "Maximum"
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "MemoryUsed-${var_lambda_function_name}"
      namespace   = local.namespace
      period      = 1 * 60 * 60
      stat        = "Maximum"
    }
  }
}
