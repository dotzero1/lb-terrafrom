variable "environment" {
  type    = string
  default = "prod"
}

variable "load_balancer_count" {
  type    = number
  default = 0
}

variable "domain_certificate_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
