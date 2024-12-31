variable "project_id" {
  description = "The project ID"
  default     = "test-project"
}

variable "location" {
  default = "asia-northeast3"
}

variable "test_app_repository_id" {
  default = "test-app-artifact-registry"
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