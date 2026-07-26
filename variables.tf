variable "project_id" {
  type        = string
  default     = "sravanth-gcp-gke-cluster"
  description = "Your Google Cloud Project ID"
}

variable "region" {
  type        = string
  default     = "northamerica-northeast1"
}

variable "cluster_name" {
  type        = string
  default     = "my-gke-cluster"
}