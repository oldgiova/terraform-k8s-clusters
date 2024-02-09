variable "kubernetes_host" {
  type        = string
  description = "Kubernetes host"
}

variable "kubernetes_client_certificate" {
  type        = string
  description = "Kubernetes client certificate"
}

variable "kubernetes_client_key" {
  type        = string
  description = "Kubernetes client key"
}

variable "kubernetes_cluster_ca_certificate" {
  type        = string
  description = "Kubernetes cluster ca certificate"
}

variable "minio_domain" {
  type        = string
  description = "minio domain"
}

variable "cluster_type" {
  type        = string
  description = "Cluster Environment Type"
  default     = "dev"
}
