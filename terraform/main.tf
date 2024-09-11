provider "google" {
  # Configuration options
  project = "your-project-id"
  region  = var.GOOGLE_REGION
}

resource "google_container_cluster" "this" {
  name     = var.GKE_CLUSTER_NAME
  location = var.GOOGLE_REGION

  initial_node_count       = 1
  remove_default_node_pool = true

    workload_identity_config {
    workload_pool = "your-project-id.svc.id.goog"
  }
  node_config {
        workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

resource "google_container_node_pool" "this" {
  name       = var.GKE_POOL_NAME
  project    = google_container_cluster.this.project
  cluster    = google_container_cluster.this.name
  location   = google_container_cluster.this.location
  node_count = var.GKE_NUM_NODES

  node_config {
    machine_type = var.GKE_MACHINE_TYPE
  }
}

module "gke_auth" {
  depends_on = [
    google_container_cluster.this
  ]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = ">= 24.0.0"
  project_id           = "your-project-id"
  cluster_name         = google_container_cluster.this.name
  location             = var.GOOGLE_REGION
}