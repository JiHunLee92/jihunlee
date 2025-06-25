################################################################################
# Route53
################################################################################

variable "zone_id" {
  type        = string
  description = "The ID of the hosted zone to contain this record."
}

variable "zone_name" {
  type        = string
  description = "The name of the hosted zone to contain this record."
}

variable "domain_prefix" {
  type        = string
  description = "The domain prefix to use for this record."
}

variable "record_type" {
  type        = string
  description = "The record type for this record."
}

variable "records" {
  type        = list(string)
  description = "A list of records for this record."
}