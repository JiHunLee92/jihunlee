variable "create_global_address" {
  type = bool
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "global_address_name" {
  type = string
}

variable "create_dns_record" {
  type = bool
}

variable "managed_zone" {
  description = "The DNS managed zone name"
  type        = string
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
    routing_policy = optional(object({
      wrr = optional(list(object({
        weight  = number
        records = list(string)
      })), [])
      geo = optional(list(object({
        location = string
        records  = list(string)
      })), [])
    }), { wrr = [], geo = [] })
  }))

  default = [
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = []
      routing_policy = {
        wrr = []
        geo = []
      }
    }
  ]
}

variable "domain_suffix" {
  description = "The complete domain suffix including the trailing dot (e.g., .lab.devnbt.com.)"
  type        = string
}

# variable "create_certificate" {
#   type = bool
# }

# variable "certificate_name" {
#   type = string
# }