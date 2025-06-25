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

variable "substitutions" {
  type    = map(string)
  default = {}
}

variable "repository_event_config" {
  type = object({
    repository   = string
    branch_regex = optional(string)
    tag_regex    = optional(string)
    invert_regex = bool
  })
}