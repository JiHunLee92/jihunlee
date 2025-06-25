variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "test-project"
}

# variable "zone" {
#   description = "The zone to deploy into"
#   type        = string
#   default     = "asia-northeast3-a"
# }

variable "test_dev_umigs" {
  description = "The instance group to create"
  type = map(object({
    name        = string
    instances   = set(string)
    named_ports = map(string)
    zone        = string
  }))
  default = {
    umig_jenkins = {
      name      = "test-dev-uig-jenkins"
      instances = ["test-dev-gce-jenkins"]
      named_ports = {
        jenkins = 8080
      }
      zone = "asia-northeast3-a"
    }
    umig_docker = {
      name      = "test-dev-uig-docker"
      instances = ["test-dev-gce-docker"]
      named_ports = {
        http = 80
      }
      zone = "asia-northeast3-a"
    }
  }
}