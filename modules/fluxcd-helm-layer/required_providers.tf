terraform {
  required_providers {
    aws = {
      version = "4.17.0"
      source  = "hashicorp/aws"
    }
    helm = {
      version = "2.5.1"
      source  = "hashicorp/helm"
    }
    kubernetes = {
      version = "2.18.1"
      source  = "hashicorp/kubernetes"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.25.1"
    }
  }
}

provider "flux" {
  # Configuration options
}
