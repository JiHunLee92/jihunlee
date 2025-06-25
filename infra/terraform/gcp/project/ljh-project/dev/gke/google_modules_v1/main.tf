locals {
  zone_list = split(",", var.zones)
}

module "devops_gke" {
  source = "../../../../../module/gke/google_modules/"

  name                       = var.devops_cluster_name
  project_id                 = var.devops_project_id
  network                    = data.terraform_remote_state.network.outputs.network.self_link
  subnetwork                 = data.terraform_remote_state.network.outputs.subnets["private_subnet"].self_link
  ip_range_pods              = var.devops_ip_range_pods
  ip_range_services          = var.devops_ip_range_services
  http_load_balancing        = var.http_load_balancing_t
  network_policy             = var.network_policy_f
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling_t
  filestore_csi_driver       = var.filestore_csi_driver_f
  dns_cache                  = var.dns_cache_f
  service_account            = var.devops_service_account
  create_service_account     = var.create_service_account_f
  deletion_protection        = var.deletion_protection_f
  region                     = var.region
  zones                      = local.zone_list
  remove_default_node_pool   = var.remove_default_node_pool_t
  gateway_api_channel        = var.devops_gateway_api_channel
  maintenance_start_time     = var.maintenance_start_time
  maintenance_end_time       = var.maintenance_end_time
  maintenance_recurrence     = var.maintenance_recurrence
  maintenance_exclusions     = var.maintenance_exclusions

  node_pools = [
    for pool in var.devops_node_pools : merge(pool, {
      machine_type    = var.machine_type
      node_locations  = var.zones
      service_account = var.devops_service_account
    })
  ]

  node_pools_oauth_scopes = var.devops_node_pools_oauth_scopes
  node_pools_labels       = var.node_pools_labels
  node_pools_metadata     = var.node_pools_metadata
  node_pools_taints       = var.node_pools_taints
  node_pools_tags         = var.node_pools_tags
}

resource "kubernetes_cluster_role_binding" "cluster_admin_binding" {
  metadata {
    name = "cluster-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = var.terraform_service_account
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [module.devops_gke]
}