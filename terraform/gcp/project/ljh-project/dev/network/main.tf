################################################################################
# VPC Module
################################################################################

module "vpc" {
  source       = "../../../../module/network/"
  network_name = "test-${var.environment}-vpc"
  project_id   = var.project_id
  region       = var.region

  subnets = {
    private_subnet = {
      subnet_name           = "test-${var.environment}-sbn-private"
      subnet_region         = var.region
      subnet_ip             = "10.10.64.0/18"
      subnet_private_access = "true"

      secondary_ip_ranges = {
        "gke-pods"     = "10.10.0.0/17"
        "gke-services" = "10.10.128.0/17"
      }
    }
    public_subnet = {
      subnet_name           = "test-${var.environment}-sbn-public"
      subnet_region         = var.region
      subnet_ip             = "10.10.0.0/18"
      subnet_private_access = "false"
    }
    internal_lb_subnet = {
      subnet_name           = "test-${var.environment}-sbn-internal"
      subnet_region         = var.region
      subnet_ip             = "10.10.128.0/18"
      subnet_private_access = "false"
      purpose               = "INTERNAL_HTTPS_LOAD_BALANCER"
      role                  = "ACTIVE"
    }
    gke_subnet = {
      subnet_name           = "test-${var.environment}-sbn-gke"
      subnet_region         = var.region
      subnet_ip             = "10.10.0.0/16"
      subnet_private_access = "true"

      secondary_ip_ranges = {
        "gke-pods"     = "192.168.0.0/17"
        "gke-services" = "192.168.128.0/17"
      }
    }
  }

  routes      = []
  router_name = "test-${var.environment}-router"
}