
resource "google_project_service" "compute_api" {
    project = var.project_id
    service = "compute.googleapis.com"
    disable_on_destroy = false
}

resource "google_project_service" "container_api" {
    project = var.project_id
    service = "container.googleapis.com"
    disable_on_destroy = false
}

resource "google_compute_network" "vpc_network" {
    project = var.project_id
    name = "vpc-network"
    auto_create_subnetworks = false

    depends_on = [google_project_service.compute_api]
}

# Create a VPC network for GKE
resource "google_compute_network" "vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.cluster_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/16"
}

# Create the GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Create a separate Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.cluster_name}-node-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}