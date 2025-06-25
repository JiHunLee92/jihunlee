data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(local.cluster_master_auth_map["cluster_ca_certificate"])

  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "gcloud"
  #   args = [
  #     "container",
  #     "clusters",
  #     "get-credentials",
  #     google_container_cluster.primary.name,
  #     "--region",
  #     var.region,
  #     "--project",
  #     var.project_id
  #   ]
  # }
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(local.cluster_master_auth_map["cluster_ca_certificate"])

    # exec {
    #   api_version = "client.authentication.k8s.io/v1beta1"
    #   command     = "gcloud"
    #   args = [
    #     "container",
    #     "clusters",
    #     "get-credentials",
    #     google_container_cluster.primary.name,
    #     "--region",
    #     var.region,
    #     "--project",
    #     var.project_id
    #   ]
    # }
  }
}
#####################################################################
# locals {
#   newrelic_app_namespace = "newrelic"
# }

# resource "helm_release" "newrelic_nri_bundle" {
#   depends_on = [google_container_cluster.primary]

#   name             = "newrelic-bundle"
#   chart            = "nri-bundle"
#   repository       = "https://helm-charts.newrelic.com"
#   namespace        = local.newrelic_app_namespace
#   create_namespace = true

#   # values.yaml 파일을 참조
#   values = [
#     file("${path.module}/helm/newrelic-values.yaml")
#   ]

#   # 또는 set 블록을 사용하여 직접 값을 설정할 수도 있습니다.
#   set {
#     name  = "global.licenseKey"
#     value = local.newrelic_license_key
#   }

#   set {
#     name  = "global.cluster"
#     value = google_container_cluster.primary.name
#   }
# }
#####################################################################
# variable "argocd_values" {
#   description = "The values to pass to the helm chart"
#   type        = list(string)
#   default     = []
# }

# resource "helm_release" "argocd" {
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "5.24.1"

#   name      = "argocd"
#   namespace = "argocd"

#   values = var.argocd_values
# }

