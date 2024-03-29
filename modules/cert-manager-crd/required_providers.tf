terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

provider "helm" {
  host                   = var.k8s.endpoint
  cluster_ca_certificate = base64decode(var.k8s.ca_certificate)
  dynamic "exec" {
    for_each = var.k8s.exec_credentials != null ? [var.k8s.exec_credentials] : []
    content {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = var.k8s.exec_credentials.command
      args        = var.k8s.exec_credentials.args
    }
  }
  config_path        = ""
  client_key         = var.k8s.client_key != "" ? base64decode(var.k8s.client_key) : ""
  client_certificate = var.k8s.client_certificate != "" ? base64decode(var.k8s.client_certificate) : ""
}

provider "kubernetes" {
  host                   = var.k8s.endpoint
  cluster_ca_certificate = base64decode(var.k8s.ca_certificate)
  dynamic "exec" {
    for_each = var.k8s.exec_credentials != null ? [var.k8s.exec_credentials] : []
    content {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = var.k8s.exec_credentials.command
      args        = var.k8s.exec_credentials.args
    }
  }
  config_path        = ""
  client_key         = var.k8s.client_key != "" ? base64decode(var.k8s.client_key) : ""
  client_certificate = var.k8s.client_certificate != "" ? base64decode(var.k8s.client_certificate) : ""
}
