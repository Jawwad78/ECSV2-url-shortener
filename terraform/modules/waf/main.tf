resource "aws_cloudwatch_log_group" "cloudwatch_waf" {
  name = var.aws_cloudwatch_log_group_name

  retention_in_days = var.retention_in_days
  }


resource "aws_wafv2_rule_group" "example" {
  name     = "waf-ecs-rule"
  scope    = var.scope
  capacity = 500

  rule {
    name     = "rate-based"
    priority = 1

    action {
      block  {}
    }

 statement {
            
            #I am using rate based since we do not know of any ip's to block currently, later we can then add/change to ip based,
            #once we know of which ip's we want to block or NEED to get blocked!
      rate_based_statement {
        aggregate_key_type = var.aggregate_key_type
        evaluation_window_sec = var.evaluation_window_sec
       limit = var.limit #this is configurable depending on how much traffic your app is getting 
      }
    }

       visibility_config { #this is for cloudwatch metrics not logs, so eg: how MANY requests matched a rule and were allowed/blocked
                           # you exact ip. For that, configure cloudwatch logs
      cloudwatch_metrics_enabled = true
      metric_name                = var.metric_name
      sampled_requests_enabled   = false
    }
  }

     visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = var.metric_name
      sampled_requests_enabled   = false
    }
  }


  resource "aws_wafv2_web_acl" "example" {
  name  = "waf-ecs"
  scope = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "aws-waf-logs-ecs"
    sampled_requests_enabled   = true
  }

  lifecycle {
    ignore_changes = [rule]
  }
}

resource "aws_wafv2_web_acl_rule_group_association" "example" {
  rule_name   = "waf-ecs-rule"
  priority    = 1
  web_acl_arn = aws_wafv2_web_acl.example.arn

  rule_group_reference {
    arn = aws_wafv2_rule_group.example.arn
  }
}

resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.example.arn
}


# send logs to cloudwatch
resource "aws_wafv2_web_acl_logging_configuration" "example" {
  log_destination_configs = [aws_cloudwatch_log_group.cloudwatch_waf.arn]
  resource_arn            = aws_wafv2_web_acl.example.arn
}