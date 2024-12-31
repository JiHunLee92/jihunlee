module "argocd" {
  source = "../../../../module/domain/"

  project_id    = var.project_id
  managed_zone  = var.test_dev_managed_zone
  domain_suffix = var.test_base_domain

  recordsets          = var.argocd_recordsets
  global_address_name = var.argocd_global_address_name

  create_dns_record     = var.create_dns_record_t
  create_global_address = var.create_global_address_t
  # create_certificate    = var.create_certificate_t
  # certificate_name    = var.test_certificate_name  
}

module "datahub" {
  source = "../../../../module/domain/"

  project_id    = var.project_id
  managed_zone  = var.test_dev_managed_zone
  domain_suffix = var.test_base_domain

  recordsets          = var.datahub_recordsets
  global_address_name = var.datahub_global_address_name

  create_dns_record     = var.create_dns_record_t
  create_global_address = var.create_global_address_t
}