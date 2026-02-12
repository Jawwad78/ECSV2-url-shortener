variable "ecstaskexecutionrole" {
  type = string
}

variable "ecstaskrole" {
  type = string
}

variable "ecs_sg" {
  type = string
}

variable "aws_subnet_private" {
  type = list(string)
}

variable "cpu_architecture" {
  type = string
}

variable "operating_system_family" {
  type = string
}

variable "blue_lb_arn" {
  type = string
}

variable "green_lb_arn" {
  type = string
}

variable "container_name" {
  type = string
}

variable "image_arn" {
  type = string
}

variable "region" {
  type = string
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}