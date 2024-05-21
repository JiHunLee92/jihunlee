variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "test_dev_domain_prefix" {
  type    = string
  default = "api"
}

variable "test_dev_api_record_type" {
  type    = string
  default = "CNAME"
}

