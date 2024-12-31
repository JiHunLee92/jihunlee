/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "network" {
  value       = google_compute_network.this
  description = "The VPC resource being created"
}

output "network_name" {
  value       = google_compute_network.this.name
  description = "The name of the VPC being created"
}

output "network_id" {
  value       = google_compute_network.this.id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.this.self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = var.shared_vpc_host && length(google_compute_shared_vpc_host_project.this) > 0 ? google_compute_shared_vpc_host_project.this[0].project : google_compute_network.this.project
  description = "VPC project id"
}

output "subnets" {
  value       = google_compute_subnetwork.this
  description = "The created subnet resources"
}

output "routes" {
  value       = google_compute_route.this
  description = "The created routes resources"
}

# output "secondary_ranges" {
#   description = "The name of the secondary range for GKE pods"
#   value = google_compute_subnetwork.this[*].secondary_ip_range[*]
# }