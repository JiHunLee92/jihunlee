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

variable "test_trigger_name" {
  default = "test-app-trigger"
}

variable "test_location" {
  default = "asia-northeast3"
}

variable "test_filename" {
  default = "cloudbuild.yaml"
}

variable "test_substitutions" {
  type        = map(string)
  default = {
    _SECRET_NAME_1  = "test-dev-key-json"
    _SECRET_FILE_1  = "test-dev-key.json"
    _IMAGE_PATH     = "asia-northeast3-docker.pkg.dev/test-project/test-dev-artifact-registry/test-app"
    _GITHUB_REPO    = "ljh-repo/devops-kube-manifest"
    _GIT_BRANCH     = "CLDEV-7115"
    _KUSTOMIZE_PATH = "test/overlays/dev/api"
  }
}

variable "test_repository_id" {
  description = "The ID of the repository for triggering Cloud Build"
  default     = "projects/test-project/locations/asia-northeast3/connections/ljh/repositories/ljh-test-devops"
}

variable "test_repository_branch" {
  description = "Branch for triggering repository events"
  default     = null
}

variable "test_repository_tag" {
  default = "^dev-api-.*"
}

variable "test_invert_regex" {
  default = false
}