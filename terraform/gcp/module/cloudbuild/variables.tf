variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "service_account" {
  type = string
}

variable "filename" {
  type = string
}

variable "repository_event_config" {
  type = object({
    repository   = string
    branch       = string
    invert_regex = bool
  })
}