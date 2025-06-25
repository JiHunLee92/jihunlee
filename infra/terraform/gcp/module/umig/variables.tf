variable "name" {
  description = "The name of the instance group"
  type        = string
}

variable "instances" {
  description = "The instances to add to the instance group"
  type        = set(string)
}

variable "named_ports" {
  description = "Named name and named port"
  type        = map(string)
  default     = {}
}

variable "zone" {
  description = "The zone to deploy into"
  type        = string
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}