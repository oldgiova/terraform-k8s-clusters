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

variable "cluster_type" {
  type        = string
  description = "Cluster Environment Type"
  default     = "dev"
}

variable "flux_namespace" {
  type        = string
  description = "Flux namespace"
  default     = "flux-system"
}

variable "github_owner" {
  type        = string
  description = "Github Owner"
  default     = "oldgiova"
}

variable "github_repository_name" {
  type        = string
  description = "Github Repository name"
  default     = "mender-helm-gitops"
}

variable "github_gitops_branch" {
  type        = string
  description = "Github Gitops branch"
  default     = "start_from_mender_deployment"
}

variable "fluxcd_spec_interval" {
  type        = string
  description = "Default Fluxcd interval to check for reconciliation"
  default     = "1m0s"
}

variable "fluxcd_gitops_chart_location" {
  type        = string
  description = "Location of Helm Chart inside gitops repo"
  default     = "./mender/mender"
}

variable "fluxcd_chart_version_to_upgrade" {
  type        = string
  description = "Helm Chart version to upgrade"
  #default = ">=3.3.0 <3.4.0" #this updates all the minor version up to 3.4.0
  default = "*"
}

variable "fluxcd_chart_valuesfile" {
  type        = string
  description = "Location of Values file inside GitOps repo"
  default     = "./mender/mender/values-poc.yaml"
}

variable "fluxcd_helmrelease_name" {
  type        = string
  description = "Helm Release Name"
  default     = "hostedmender"
}
