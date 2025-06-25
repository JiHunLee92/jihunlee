module "test_cloudsql" {
  source = "../../../../module/cloudsql"
  vpc_id = data.terraform_remote_state.network.outputs.network.self_link

  for_each = { for instance in var.test_cloudsql_instances : instance.instance_name => instance }

  instance_name = each.value.instance_name
  # master_instance_name = each.value.master_instance_name
  project_id = each.value.project_id
  # database_name       = each.value.database_name
  database_version        = each.value.database_version
  region                  = each.value.region
  machine_type            = each.value.machine_type
  edition                 = each.value.edition
  deletion_protection     = each.value.deletion_protection
  database_flags          = each.value.database_flags
  maintenance_window_day  = each.value.maintenance_window_day
  maintenance_window_hour = each.value.maintenance_window_hour
}