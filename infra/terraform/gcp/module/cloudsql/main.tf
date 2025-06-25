resource "google_sql_database_instance" "cloud_sql_instance" {
  name                 = var.instance_name
  database_version     = var.database_version
  region               = var.region
  master_instance_name = var.master_instance_name
  deletion_protection  = var.deletion_protection

  settings {
    tier              = var.machine_type
    edition           = var.edition
    availability_type = var.availability_type
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    disk_autoresize   = var.disk_autoresize
    deletion_protection_enabled = var.deletion_protection_enabled

    ip_configuration {
      ipv4_enabled       = false
      private_network    = var.vpc_id
      allocated_ip_range = var.allocated_ip_range
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    backup_configuration {
      enabled = true

      location           = var.backup_configuration_location
      binary_log_enabled = var.backup_configuration_binary_log_enabled
    }

    dynamic "maintenance_window" {
      for_each = var.master_instance_name != null ? [] : ["true"]

      content {
        day          = var.maintenance_window_day
        hour         = var.maintenance_window_hour
        update_track = var.maintenance_window_update_track
      }
    }
    # dynamic "insights_config" {
    #   for_each = var.insights_config != null ? [var.insights_config] : []

    #   content {
    #     query_insights_enabled  = true
    #     query_plans_per_minute  = insights_config.value.query_plans_per_minute
    #     query_string_length     = insights_config.value.query_string_length
    #     record_application_tags = insights_config.value.record_application_tags
    #     record_client_address   = insights_config.value.record_client_address
    #   }
    # }
  }
}

# resource "google_sql_database" "cloudsql" {
#   name     = var.database_name
#   instance = google_sql_database_instance.cloud_sql_instance.name
# }