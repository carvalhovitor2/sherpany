variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "system" {
  type = string
}

variable "aws_auth_users" {
  type = list(any)
}
