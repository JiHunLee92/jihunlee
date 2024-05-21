/******************************************
	Compute_Instance 
 *****************************************/
 
resource "google_compute_address" "this" {
  count = var.reserve_ip ? 1 : 0

  name    = "${var.hostname}-ip"
  project = var.project_id
  region  = var.region
}

resource "google_compute_disk" "this" {
  count = length(var.additional_disks)

  name = var.additional_disks[count.index].name
  zone = var.zone
  size = var.additional_disks[count.index].size
  type = var.additional_disks[count.index].type
}

resource "google_compute_instance" "this" {
  depends_on = [google_compute_address.this, google_compute_disk.this]

  name         = var.hostname
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.boot_disk_size
      type  = "pd-standard"
    }
  }

  dynamic "attached_disk" {
    for_each = {
      for disk in google_compute_disk.this :
      disk.name => {
        name = disk.name
      }
    }
    content {
      source      = attached_disk.value.name
      device_name = attached_disk.value.name
    }
  }
  
  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project

    dynamic "access_config" {
      for_each = {
        for addr in google_compute_address.this :
        addr.name => {
          address = addr.address
          tier    = addr.network_tier
        }
      }

      content {
        nat_ip       = access_config.value.address
        network_tier = access_config.value.tier
      }
    }

    # dynamic "ipv6_access_config" {
    #   for_each = var.ipv6_access_config
    #   content {
    #     network_tier = ipv6_access_config.value.network_tier
    #   }
    # }

    # dynamic "alias_ip_range" {
    #   for_each = var.alias_ip_ranges
    #   content {
    #     ip_cidr_range         = alias_ip_range.value.ip_cidr_range
    #     subnetwork_range_name = alias_ip_range.value.subnetwork_range_name
    #   }
    # }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags   = var.tags
  # labels = var.labels
  # deletion_protection = var.deletion_protection
  # resource_policies   = var.resource_policies

  # params {
  #   resource_manager_tags = var.resource_manager_tags
  # }
  # source_instance_template = var.instance_template

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}