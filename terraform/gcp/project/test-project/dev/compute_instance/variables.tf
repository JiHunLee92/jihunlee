variable "project_id" {
  description = "Project id of the project that holds the network."
  type        = string
  default     = "test-dev"
}

variable "region" {
  description = "The region to deploy into"
  default     = "asia-northeast3"
}

variable "zone" {
  description = "The zone to deploy into"
  default     = "asia-northeast3-a"
}

variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  type        = string
  default     = "test-dev-sbn-public"
}

variable "public_instances" {
  type = map(object({
    hostname       = string
    machine_type   = string
    zone           = string
    image          = string
    tags           = list(string)
    boot_disk_size = number
    additional_disks = list(object({
      name = optional(string, null)
      size = number
      type = string
    }))
    reserve_ip = optional(bool, true)
    labels     = map(string)
  }))
  default = {
    gateway_public = {
      hostname         = "test-dev-gateway-public"
      machine_type     = "g1-small"
      zone             = "asia-northeast3-a"
      image            = "ubuntu-os-cloud/ubuntu-2004-focal-v20221018"
      tags             = ["office-ssh"]
      boot_disk_size   = 10
      additional_disks = []
      labels = {
        role       = "gateway"
        osversion  = "ubuntu_2004"
        env        = "dev"
        team       = "devops"
        service    = "test-dev"
        permission = "public"
        os         = "ubuntu"
      }
    }
  }
}

variable "private_instances" {
  type = map(object({
    hostname       = string
    machine_type   = string
    zone           = string
    image          = string
    tags           = list(string)
    boot_disk_size = number
    additional_disks = list(object({
      name = optional(string, null)
      size = number
      type = string
    }))
    reserve_ip = optional(bool, false)
    labels     = map(string)
  }))
  default = {
    gateway_private = {
      hostname         = "test-dev-gateway"
      machine_type     = "g1-small"
      zone             = "asia-northeast3-a"
      image            = "test-dev/security-os"
      tags             = ["office-ssh"]
      boot_disk_size   = 20
      additional_disks = []
      labels = {
        role       = "gateway"
        osversion  = "ubuntu_2004"
        env        = "dev"
        team       = "devops"
        service    = "test-dev"
        permission = "private"
        os         = "ubuntu"
      }
    }
    docker = {
      hostname         = "test-dev-docker"
      machine_type     = "n1-standard-1"
      zone             = "asia-northeast3-a"
      image            = "test-dev/security-os"
      boot_disk_size   = 20
      additional_disks = []
      tags             = []
      labels = {
        "env"        = "dev"
        "os"         = "ubuntu"
        "osversion"  = "ubuntu_2004"
        "role"       = "web"
        "service"    = "data"
        "team"       = "devops"
        "permission" = "private"
      }
    }
  }
}