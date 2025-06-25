module "firewall" {
  source       = "../../../../module/firewall/"
  project_id   = var.project_id
  network_name = data.terraform_remote_state.network.outputs.network_name

  ingress_rules = {
    fw_allow_office_ssh = {
      name          = "test-dev-fw-allow-office-ssh"
      source_ranges = ["1.1.1.1/32", "10.10.10.0/24"]
      target_tags   = ["office-ssh"]
      priority      = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
    }
    fw_hck = {
      name          = "test-dev-fw-hck"
      source_ranges = ["2.2.2.2/16", "3.3.3.3/22"]
      priority      = 1000
      allow = [
        {
          protocol = "tcp",
          ports    = ["80", "443", "8082", "8080", "11222"]
        }
      ]
    }
  }
  egress_rules = {}
}