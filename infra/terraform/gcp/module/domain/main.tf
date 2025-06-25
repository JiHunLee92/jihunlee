# DNS Record Set
resource "google_dns_record_set" "cloud_static_records" {
  for_each = var.create_dns_record ? { for record in var.recordsets : join("/", [record.name, record.type]) => record } : {}

  project      = var.project_id
  managed_zone = var.managed_zone

  name = (each.value.name != "" ? "${each.value.name}${var.domain_suffix}" : var.domain_suffix)

  type    = each.value.type
  ttl     = each.value.ttl
  rrdatas = length(each.value.routing_policy.wrr) == 0 && length(each.value.routing_policy.geo) == 0 ? (length(each.value.records) > 0 ? each.value.records : (local.get_global_ip != null ? [local.get_global_ip] : [])) : null

  dynamic "routing_policy" {
    for_each = length(each.value.routing_policy.wrr) > 0 || length(each.value.routing_policy.geo) > 0 ? ["enabled"] : []
    content {
      dynamic "wrr" {
        for_each = each.value.routing_policy.wrr
        iterator = wrr
        content {
          weight  = wrr.value.weight
          rrdatas = length(wrr.value.records) > 0 ? wrr.value.records : (local.get_global_ip != null ? [local.get_global_ip] : [])
        }
      }

      dynamic "geo" {
        for_each = each.value.routing_policy.geo
        iterator = geo
        content {
          location = geo.value.location
          rrdatas  = length(wrr.value.records) > 0 ? wrr.value.records : (local.get_global_ip != null ? [local.get_global_ip] : [])
        }
      }
    }
  }

  depends_on = [google_compute_global_address.global_ip]
}

# # Certificate
# resource "google_certificate_manager_certificate" "default" {
#   count   = var.create_certificate ? 1 : 0
#   project = var.project_id
#   name    = var.certificate_name
#   managed { 
#     domains = local.certificate_domains
#   }

#   depends_on = [google_compute_global_address.global_ip]
# }