#Purpose: Provision a GKE cluster with node pools and networking.

provider "google" {
  project = "my-gcp-project"
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name               = "primary-cluster"
  location           = "us-central1-a"
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 100
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "high_memory" {
  name       = "high-memory-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  initial_node_count = 2

  node_config {
    machine_type = "n1-highmem-4"
  }
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}
