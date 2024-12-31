variable "project_id" {
  description = "The project ID"
  default     = "test-project"
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

variable "test_name" {
  default = "test-app-trigger"
}

variable "test_location" {
  default = "asia-northeast3"
}

variable "test_filename" {
  default = "cloudbuild.yaml"
}

variable "test_repository_id" {
  description = "The ID of the repository for triggering Cloud Build"
  default     = "projects/test-project/locations/asia-northeast3/connections/ljh/repositories/ljh-test-devops"
}

variable "test_repository_branch" {
  description = "Branch for triggering repository events"
  default     = "^develop$"
}

variable "test_invert_regex" {
  default = false
}