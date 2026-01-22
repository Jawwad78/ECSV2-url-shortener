
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "sg_80" {
  type = number
}

variable "sg_443" {
  type = number
}

variable "ssl_policy" {
  type = string
}

variable "certificate_arn" {
  type = string
}