variable "project_id" {
  description = "The project ID where resources will be created"
  type        = string
}

variable "vpc_id" {
  description = "The self link of the VPC network"
  type        = string
}


variable "instance_name" {
  description = "The name of the existing instance that will act as the master in the replication setup."
  type        = string
  default     = null
}

variable "master_instance_name" {
  description = "The name of the existing instance that will act as the master in the replication setup."
  type        = string
  default     = null
}

# variable "database_name" {
#   description = "The Cloud SQL instance name"
#   type        = string
# }

variable "database_version" {
  description = "The database version for Cloud SQL"
  type        = string
}

variable "region" {
  description = "Region for Cloud SQL instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type for Cloud SQL instance"
  type        = string
}

variable "edition" {
  description = "The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS."
  type        = string
  default     = null
}

variable "availability_type" {
  description = "The availability type for the master instance. Can be either `REGIONAL` or `null`."
  type        = string
  default     = "ZONAL"
}

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "The disk size for the master instance"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD_SSD"
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}
# variable "insights_config" {
#   description = "Insights configuration for Cloud SQL instance"
#   type = object({
#     query_plans_per_minute  = optional(number, 5)
#     query_string_length     = optional(number, 1024)
#     record_application_tags = optional(bool, false)
#     record_client_address   = optional(bool, false)
#   })
#   default = null
# }
# variable "insights_config" {
#   description = "Insights configuration for Cloud SQL instance"
#   type = list(any)
#   default = null
# }