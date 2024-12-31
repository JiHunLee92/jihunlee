output "global_ip_address" {
  description = "The created global IP address"
  value       = var.create_global_address ? google_compute_global_address.global_ip[0].address : null
}

output "dns_records" {
  description = "The created DNS records"
  value       = google_dns_record_set.cloud_static_records
}

# output "certificate_id" {
#   description = "The ID of the created certificate"
#   value       = var.create_certificate ? google_certificate_manager_certificate.default[0].id : null
# }