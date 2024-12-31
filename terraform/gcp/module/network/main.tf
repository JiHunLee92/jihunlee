/******************************************
	VPC 
  Link: https://github.com/terraform-google-modules/terraform-google-network
 *****************************************/
resource "google_compute_network" "this" {
  name                                      = var.network_name
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  project                                   = var.project_id
  description                               = var.description
  delete_default_routes_on_create           = var.delete_default_internet_gateway_routes
  mtu                                       = var.mtu
  enable_ula_internal_ipv6                  = var.enable_ipv6_ula
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
}

/******************************************
	Shared VPC
 *****************************************/
resource "google_compute_shared_vpc_host_project" "this" {
  provider = google-beta

  count      = var.shared_vpc_host ? 1 : 0
  project    = var.project_id
  depends_on = [google_compute_network.this]
}

/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "this" {
  for_each = var.subnets

  name                       = each.value.subnet_name
  ip_cidr_range              = each.value.subnet_ip
  region                     = each.value.subnet_region
  private_ip_google_access   = lookup(each.value, "subnet_private_access", "false")
  private_ipv6_google_access = lookup(each.value, "subnet_private_ipv6_access", null)
  network                    = var.network_name
  project                    = var.project_id
  description                = lookup(each.value, "description", null)

  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ip_ranges", {})

    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }

  dynamic "log_config" {
    for_each = coalesce(lookup(each.value, "subnet_flow_logs", null), false) ? [{
      aggregation_interval = each.value.subnet_flow_logs_interval
      flow_sampling        = each.value.subnet_flow_logs_sampling
      metadata             = each.value.subnet_flow_logs_metadata
      filter_expr          = each.value.subnet_flow_logs_filter
      metadata_fields      = each.value.subnet_flow_logs_metadata_fields
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
      filter_expr          = log_config.value.filter_expr
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? log_config.value.metadata_fields : null
    }
  }

  purpose          = lookup(each.value, "purpose", null)
  role             = lookup(each.value, "role", null)
  stack_type       = lookup(each.value, "stack_type", null)
  ipv6_access_type = lookup(each.value, "ipv6_access_type", null)

  lifecycle {
    ignore_changes = [
      "log_config",
      "private_ip_google_access",
      "private_ipv6_google_access",
      "purpose",
      "role",
      "stack_type",
      "ipv6_access_type",
    ]
  }
}


locals {
  routes = {
    for i, route in var.routes :
    lookup(route, "name", format("%s-%s-%d", lower(var.network_name), "route", i)) => route
  }
}

/******************************************
	Routes
 *****************************************/
resource "google_compute_route" "this" {
  for_each = local.routes

  project = var.project_id
  network = var.network_name

  name                   = each.key
  description            = lookup(each.value, "description", null)
  tags                   = compact(split(",", lookup(each.value, "tags", "")))
  dest_range             = lookup(each.value, "destination_range", null)
  next_hop_gateway       = lookup(each.value, "next_hop_internet", "false") == "true" ? "default-internet-gateway" : null
  next_hop_ip            = lookup(each.value, "next_hop_ip", null)
  next_hop_instance      = lookup(each.value, "next_hop_instance", null)
  next_hop_instance_zone = lookup(each.value, "next_hop_instance_zone", null)
  next_hop_vpn_tunnel    = lookup(each.value, "next_hop_vpn_tunnel", null)
  next_hop_ilb           = lookup(each.value, "next_hop_ilb", null)
  priority               = lookup(each.value, "priority", null)

  depends_on = [var.module_depends_on]
}

/******************************************
	Router
 *****************************************/
resource "google_compute_router" "this" {
  name    = var.router_name
  region  = var.region
  network = var.network_name

  bgp {
    asn = 64514
  }
}

## NAT IP
#resource "google_compute_address" "this" {
#  count  = var.nat_ips_count
#  name   = "${var.nat_name}-ip-${count.index}"
#  region = var.region
#}

## NAT
#resource "google_compute_router_nat" "this" {
#  name   = var.nat_name
#  router = var.router_name
#  region = var.region

#  nat_ip_allocate_option = "MANUAL_ONLY"
#  nat_ips                = google_compute_address.this.*.self_link

#  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

#  #subnetwork {
#  #  name                    = "${var.network_name}-${var.environment}-sbn-private"
#  #  #source_ip_ranges_to_nat = [var.private_subnets_cidr]
#  #  source_ip_ranges_to_nat = var.private_subnets_cidr
#  #}

#  dynamic "subnetwork" {
#      for_each = var.nat_subnets
#      content {
#        name = subnetwork.value.subnet_name
#        source_ip_ranges_to_nat = [subnetwork.value.subnet_ip]
#      }
#  }

#  log_config {
#    enable = true
#    filter = "ERRORS_ONLY"
#  }

#  lifecycle {ignore_changes = [subnetwork]}
#}