resource "google_compute_instance_group" "this" {
  project   = var.project_id
  name      = var.name
  instances = var.instances
  zone      = var.zone

  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.key
      port = named_port.value
    }
  }
  lifecycle { ignore_changes = [instances] }
}