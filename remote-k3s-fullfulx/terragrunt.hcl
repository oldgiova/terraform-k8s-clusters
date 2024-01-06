generate "provider" {
  path      = "${get_terragrunt_dir()}/provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "k3s01.oldgiova.sh"
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "k3s01.oldgiova.sh"
  }
}
provider "kubectl" {
  config_path = "~/.kube/config"
  config_context = "k3s01.oldgiova.sh"
}
EOF
}

generate "required_provider" {
  path      = "${get_terragrunt_dir()}/gen_required_provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.25.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
EOF
}
