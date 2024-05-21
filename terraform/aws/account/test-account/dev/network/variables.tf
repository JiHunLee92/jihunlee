################################################################################
# VPC Module
################################################################################

variable "name" {
  default = "test"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.222.0.0/16"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "azs" {
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnets" {
  default = ["10.222.0.0/20", "10.222.32.0/20"]
}

variable "private_subnets" {
  default = ["10.222.16.0/20", "10.222.48.0/20"]
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}