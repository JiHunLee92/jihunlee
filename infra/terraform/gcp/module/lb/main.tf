resource "google_compute_managed_ssl_certificate" "this" {
  # count = local.external ? 1 : 0
  count = 0

  provider = google
  name     = var.certificate_name

  managed {
    domains = [var.domain_name]
  }
}

locals {
  external = var.load_balancing_scheme == "EXTERNAL" ? true : false
}

resource "google_compute_global_address" "this" {
  project = var.project_id
  name    = "${var.lb_name}-lb-ip"
}

resource "google_compute_target_https_proxy" "this" {
  depends_on = [google_compute_managed_ssl_certificate.this]
  count      = local.external ? 1 : 0

  name    = "${var.lb_name}-lb-proxy"
  url_map = "https://www.googleapis.com/compute/v1/projects/test-project/global/urlMaps/test-dev-lb"
}

resource "google_compute_global_forwarding_rule" "this" {
  count = local.external ? 1 : 0

  name                  = "${var.lb_name}-lb-fw-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.this[0].id
  ip_address            = google_compute_global_address.this.address
}


resource "google_compute_url_map" "this" {
  name = var.lb_name
  # default_service = var.default_service
  default_service = "https://www.googleapis.com/compute/v1/projects/test-project/global/backendServices/test-dev-bnd"
}

# resource "google_compute_url_map" "this" {
#   depends_on = [google_compute_backend_service.this]

#   name = var.lb_name
#   # description = "a description"

#   default_service = var.default_service

#   # host_rule {
#   #   hosts        = ["mysite.com"]
#   #   path_matcher = "mysite"
#   # }

#   # host_rule {
#   #   hosts        = ["myothersite.com"]
#   #   path_matcher = "otherpaths"
#   # }

#   # test {
#   #   service = google_compute_backend_bucket.static.id
#   #   host    = "example.com"
#   #   path    = "/home"
#   # }
# }

resource "google_compute_backend_service" "this" {
  for_each = var.backend_services

  project = var.project_id

  name          = each.value.bnd_name
  protocol      = each.value.protocol
  port_name     = each.value.port_name
  timeout_sec   = var.timeout_sec
  health_checks = [each.value.health_check_id]

  load_balancing_scheme = var.load_balancing_scheme
  security_policy       = each.value.security_policy

  backend {
    group           = each.value.target_group_id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
    max_utilization = 1
  }

  # dynamic "iap" {
  #   for_each = var.enable_iap ? ["enabled"] : []
  #   content {
  #     oauth2_client_id     = var.oauth2_client_id
  #     oauth2_client_secret = var.oauth2_client_secret
  #   }
  # }
}


# # internal ip
# resource "google_compute_address" "this" {
#   count = local.external ? 0 : 1
#   name  = "${var.lb_name}-internal-lb-ip"
# }

# resource "google_compute_forwarding_rule" "this" {
#   count = local.external ? 0 : 1

#   name                  = ""
#   region                = var.region
#   ip_protocol           = "TCP"
#   load_balancing_scheme = var.load_balancing_scheme
#   port_range            = "80"
#   target                = google_compute_region_target_http_proxy.this[0].id
#   # network               = module.vpc.vpc_id
#   # subnetwork            = module.private_subnets.subnet_id
#   network_tier          = "PREMIUM"
# }

# resource "google_compute_region_target_http_proxy" "this" {
#   count = local.external ? 0 : 1

#   region  = var.region
#   name    = "${lb_name}-internal-lb-fw-rule"
#   url_map = google_compute_region_url_map.this.id
# }

# resource "google_compute_region_url_map" "this" {
# }