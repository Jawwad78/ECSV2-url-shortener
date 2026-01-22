variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "sg_80" {
  type = number
}

variable "sg_443" {
  type = number
}

