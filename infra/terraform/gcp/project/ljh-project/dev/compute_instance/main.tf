locals {
  public_instances = { for instance in var.public_instances : instance.hostname => merge(instance, {
    subnetwork = data.terraform_remote_state.network.outputs.subnets["public_subnet"].name
    metadata   = { enable-oslogin = "TRUE" }
  }) }
  private_instances = { for instance in var.private_instances : instance.hostname => merge(instance, {
    subnetwork = data.terraform_remote_state.network.outputs.subnets["private_subnet"].name
    metadata = {
      enable-oslogin = "FALSE"
      ssh-keys       = "devops:${data.local_file.public_key_openssh.content}"
    }
  }) }
  all_instances = merge(local.public_instances, local.private_instances)
}

module "compute_instances" {
  source   = "../../../../module/compute_instance/"
  for_each = local.all_instances

  zone               = each.value.zone
  image              = each.value.image
  subnetwork_project = var.project_id
  subnetwork         = each.value.subnetwork
  hostname           = each.value.hostname
  machine_type       = each.value.machine_type
  boot_disk_size     = each.value.boot_disk_size
  additional_disks   = each.value.additional_disks
  reserve_ip         = each.value.reserve_ip
  labels             = each.value.labels
  tags               = each.value.tags
  metadata           = each.value.metadata

  project_id = var.project_id
  region     = var.region
}