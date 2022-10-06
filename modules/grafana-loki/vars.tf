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

variable "loki_chart_version" {
  type = string
  description = "loki-simple-scalable chart version - see tags https://github.com/grafana/helm-charts/tree/loki-simple-scalable-1.8.11"
  default = "1.8.11"
}

variable "loki_s3_url" {
  type = bool
  description = "Loki storage S3 enabled"
}
