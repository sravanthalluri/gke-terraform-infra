variable "project_id" {
  type        = string
  description = "Your Google Cloud Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  type        = string
  default     = "my-gke-cluster"
}