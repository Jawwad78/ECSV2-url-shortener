variable "alb_arn" {
  type = string
}

variable "aws_cloudwatch_log_group_name" {
  type = string
}

variable "retention_in_days" {
  type = number
}

variable "scope" {
  type = string
}

variable "aggregate_key_type" {
  type = string
}

variable "evaluation_window_sec" {
  type = number
}

variable "limit" {
  type = number
}

variable "metric_name" {
  type = string
}