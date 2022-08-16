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

variable "mongodb_root_password" {
  type        = string
  description = "Mongodb root password"
}

variable "minio_domain_name" {
  type        = string
  description = "Minio Domain Name"
}

variable "minio_access_key" {
  type        = string
  description = "Minio Access Key"
}

variable "minio_secret_key" {
  type        = string
  description = "Minio Secret key"
}

variable "mender_server_domain" {
  type        = string
  description = "Mender Server Domain"
}

variable "cluster_type" {
  type        = string
  description = "Cluster Environment Type"
  default     = "dev"
}
