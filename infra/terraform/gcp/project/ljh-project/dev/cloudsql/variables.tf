variable "project_id" {
  description = "Project id of the project that holds the network."
  type        = string
  default     = "test-project"
}

variable "zone" {
  description = "The zone to deploy into"
  default     = "asia-northeast3-a"
}

variable "GOOGLE_CREDENTIALS" {
  description = "The credentials to access Google Cloud"
  type        = string
  sensitive   = true
}

variable "test_cloudsql_instances" {
  description = "List of CloudSQL instances with individual settings"
  type = list(object({
    instance_name       = string
    project_id          = string
    database_version    = string
    region              = string
    machine_type        = string
    edition             = string
    deletion_protection = bool
    database_flags = list(object({
      name  = string
      value = string
    }))
    maintenance_window_day  = number
    maintenance_window_hour = number
  }))
  default = [
    {
      instance_name           = "test-dev-sql"
      project_id              = "test-project"
      database_version        = "MYSQL_8_0"
      region                  = "asia-northeast3"
      machine_type            = "db-f1-micro"
      edition                 = "ENTERPRISE" ## The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS.
      maintenance_window_day  = 3            ## the day of week (1-7) UTC day 3 hour 19
      maintenance_window_hour = 19           ## UTC (KST 04 hour)
      deletion_protection     = true
      database_flags = [
        {
          name  = "slow_query_log"
          value = "on"
        },
        {
          name  = "long_query_time"
          value = "2"
        },
        {
          name  = "character_set_server"
          value = "utf8mb4"
        },
        {
          name  = "default_time_zone"
          value = "+09:00"
        },
        {
          name  = "sql_mode"
          value = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION"
        }
      ]
    }
  ]
}