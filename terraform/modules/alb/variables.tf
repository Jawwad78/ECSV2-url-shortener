variable "ssl_policy" {
  type = string
}

variable "sg_80" {
  type = number
}

variable "sg_443" {
  type = number
}

variable "aws_subnet_public" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg" {
  type = string
}

variable "aws_acm_certificate_arn" {
  type = string
}