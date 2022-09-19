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

variable "oncall_base_url" {
  type = string
  description = "Grafana OnCall Base Url"
  default = "oncall.example.org"
}

variable "oncall_engine_replica_count" {
  type = number
  description = "Grafana OnCall Engine Replica count"
  default = 1
}

variable "oncall_celery_replica_count" {
  type = number
  description = "Grafana OnCall Celery Replica count"
  default = 1
}

variable "oncall_slack_enabled" {
  type = bool
  description = "slack enabled"
  default = false
}

variable "oncall_ingress_annotations_ingress_class" {
  type = string
  description = "Ingress Class for ingress"
  default = "nginx"
}

variable "oncall_cert_manager_issuer_name" {
  type = string
  description = "Cert Manager issuer name"
  default = "selfsigned"
}

variable "oncall_ingress_secretName" {
  type = string
  description = "Default secretName"
  default = "oncall-certificate-tls"
}

variable "oncall_ingress_nginx_enabled" {
  type = bool
  description = "whether to install ingress controller"
  default = false
}

variable "oncall_cert_manager_enabled" {
  type = bool
  description = "Install cert-manager as part of the release"
  default = false
}

variable "oncall_mariadb_enabled" {
  type = bool
  description = "Mariadb enabled inside k8s"
  default = false
}

variable "oncall_externalmmsql_host" {
  type = string
  description = "Mysql external host"
  default = ""
}

variable "oncall_externalmmsql_port" {
  type = number
  description = "Mysql external port"
  default = 3306
}

variable "oncall_externalmmsql_db_name" {
  type = string
  description = "Mysql external db name"
  default = "oncall"
}

variable "oncall_externalmmsql_user" {
  type = string
  description = "Mysql external user"
  default = "sre-user"
}

# variable "oncall_externalmmsql_password" {
#   type = string
#   description = "Mysql external password"
# }

variable "oncall_grafana_enabled" {
  type = bool
  description = "Grafana included"
  default = true
}








