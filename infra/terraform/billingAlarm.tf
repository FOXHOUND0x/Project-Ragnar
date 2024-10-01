resource "aws_sns_topic" "billing_alarm_topic" {
    name = "ragnar_billing_alarm_topic"
}

resource "aws_sns_topic_subscription" "billing_alarm_topic_subscription" {
    topic_arn = aws_sns_topic.billing_alarm_topic.arn
    protocol = "email"
    endpoint = "foxhound@the0x.dev"
}

resource "aws_cloudwatch_metric_alarm" "ragnar_billing_alarm" {
    alarm_name = "ragnar_billing_alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 120
    statistic = "Average"
    threshold = 80
    alarm_description = "This metric monitors the cost associated with this personal project."
    insufficient_data_actions = []
}