resource "google_compute_health_check" "this" {
  name        = var.health_check_name
  description = var.health_check_description

  timeout_sec         = var.timeout_sec
  check_interval_sec  = var.check_interval_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  project = var.project_id
  dynamic "tcp_health_check" {
    for_each = { for k, v in var.params : k => v if v.request_path == "" }
    content {
      port = tcp_health_check.value.port
    }
  }

  dynamic "http_health_check" {
    for_each = { for k, v in var.params : k => v if v.request_path != "" }
    content {
      port         = http_health_check.value.port
      request_path = http_health_check.value.request_path
      # port_specification = "USE_NAMED_PORT"
      # host               = "
    }
  }
}