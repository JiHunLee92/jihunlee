variable "project_id" {
  description = "The project ID"
  default     = "test-project"
}

variable "test_dns_managed_zone" {
  description = "The managed zone for DNS"
  default     = "test-dev-com"
}

variable "test_base_domain" {
  default = "test.dev.com."
}

variable "argocd_recordsets" {
  description = "List of DNS records with optional routing policies"
  default = [
    {
      name    = "argocd."
      type    = "A"
      ttl     = 300
      records = ["1.1.1.1"]
      routing_policy = {
        wrr = []
        geo = []
      }
    }
  ]
}

variable "argocd_global_address_name" {
  description = "The name of the global address for ArgoCD"
  default     = "devops-dev-cluster-1-30-5-argo-cd-static-ip"
}

variable "datahub_recordsets" {
  description = "List of DNS records with optional routing policies"
  default = [
    {
      name    = "datahub."
      type    = "A"
      ttl     = 300
      records = []
      routing_policy = {
        wrr = [
          { weight = 0, records = [] },
          { weight = 100, records = ["1.1.1.1"] }
        ]
        geo = []
      }
    }
  ]
}

variable "datahub_global_address_name" {
  description = "The name of the global address for ArgoCD"
  default     = "devops-dev-cluster-1-30-5-datahub-static-ip"
}

variable "create_dns_record_t" {
  description = "Flag to create DNS record set"
  type        = bool
  default     = true
}

variable "create_global_address_t" {
  description = "Flag to create Global Address"
  type        = bool
  default     = true
}

variable "create_dns_record_f" {
  description = "Flag to create DNS record set"
  type        = bool
  default     = false
}

variable "create_global_address_f" {
  description = "Flag to create Global Address"
  type        = bool
  default     = false
}

variable "TF_VAR_GOOGLE_CREDENTIALS" {
  description = "Environment variable for Google credentials"
  type        = string
  sensitive   = true
}

variable "GOOGLE_CREDENTIALS" {
  description = "The credentials to access Google Cloud"
  type        = string
  sensitive   = true
}

# variable "test_certificate_name" {
#   description = "The name of the certificate for ArgoCD"
#   default     = "test-ljh-lab-devnbt-com"
# }

# variable "create_certificate_t" {
#   description = "Flag to create SSL Certificate"
#   type        = bool
#   default     = true
# }

# variable "create_certificate_f" {
#   description = "Flag to create SSL Certificate"
#   type        = bool
#   default     = false
# }