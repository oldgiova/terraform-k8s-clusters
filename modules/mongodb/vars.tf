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

variable "mongodb_persistence_size" {
  type        = string
  description = "Mongodb persistence size"
  default     = "8Gi"
}

variable "mongodb_image_tag" {
  type        = string
  description = "Mongodb Image Tag"
  default     = "4.4.13-debian-10-r63"
}

variable "mongodb_replica_count" {
  type        = number
  description = "Mongodb replica count"
  default     = 2
}

variable "cluster_type" {
  type        = string
  description = "Cluster Environment Type"
  default     = "dev"
}
