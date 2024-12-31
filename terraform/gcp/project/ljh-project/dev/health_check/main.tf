locals {
  health_checks = merge(
    var.tcp_health_checks,
    var.http_health_checks,
  )
}

module "health_check" {
  source = "../../../../module/health_check/"

  project_id = var.project_id
  for_each   = local.health_checks

  health_check_name = each.value.name
  params = {
    "${each.key}" = {
      port         = each.value.port
      request_path = try(each.value.request_path, "")
    }
  }

  # timeout_sec         = var.timeout_sec
  # check_interval_sec  = var.check_interval_sec
  # healthy_threshold   = var.healthy_threshold
  # unhealthy_threshold = var.unhealthy_threshold
}