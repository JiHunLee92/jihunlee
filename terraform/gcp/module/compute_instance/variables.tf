variable "project_id" {
  description = "The project id of the project that holds the network."
  type        = string
}

variable "region" {
  description = "The region to deploy into"
  default     = "asia-northeast3"
}

variable "hostname" {
  description = "The hostname of the instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the instance"
  type        = string
}

variable "zone" {
  description = "The zone to deploy into"
  # default     = "asia-northeast3-a"
}

variable "image" {
  description = "The image to use for the instance"
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the boot disk"
  type        = string
  default     = "10"
}

variable "additional_disks" {
  description = "Additional disks to attach to the instance"
  type = list(object({
    name = string
    size = number
    type = string
  }))
}

variable "reserve_ip" {
  description = "Reserve an IP address for the instance"
  type        = bool
  default     = false
}

variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  type        = string
}

variable "subnetwork_project" {
  description = "The project that subnetwork belongs to"
  type        = string
}

variable "labels" {
  description = "Labels to override those from the template, provided as a map"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A list of network tags to attach to the instance"
  type        = list(string)
  default     = []
}