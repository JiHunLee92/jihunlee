module "test_dev_umig" {
  source   = "../../../../module/umig/"
  for_each = var.test_dev_umigs

  name      = each.value.name
  instances = each.value.instances

  project_id  = var.project_id
  zone        = each.value.zone
  named_ports = each.value.named_ports
}