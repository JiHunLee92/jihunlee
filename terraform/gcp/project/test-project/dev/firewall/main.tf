module "firewall" {
  source = "../../../../module/firewall/"
  project_id = var.project_id
  network_name = data.terraform_remote_state.network.outputs.network_name

  ingress_rules = {
    fw_allow_office_ssh = {
      name = "test-dev-fw-allow-office-ssh"
      description = "Allow SSH from the office"
      source_ranges = ["0.0.0.0/0"]
      target_tags = ["office-ssh"]
      priority = 1000
      allow = [{
        protocol = "tcp"
        ports = ["22"]
      }]
    }
    fw_allow_internal_ssh = {
      name = "test-dev-fw-allow-internal-ssh"
      source_ranges = ["10.0.0.0/24"]
      priority = 1000
      allow = [{
        protocol = "tcp"
        ports = ["22"]
      }]
    }
    fw_hck = {
      name = "test-dev-fw-hck"
      source_ranges = ["11.11.11.11/16"]
      priority = 1000
      allow = [
        { 
          protocol = "tcp", 
          ports = ["80", "443", "8082", "8080", "11222"] 
        }
      ]
    }
  }
  egress_rules = {}
}