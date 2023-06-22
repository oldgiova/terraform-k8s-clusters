data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_id
}

data "aws_region" "current" {}

provider "kubernetes" {
  host                   = var.eks_host
  cluster_ca_certificate = base64decode(var.eks_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  config_path            = ""
}

provider "helm" {
  kubernetes {
    host                   = var.eks_host
    cluster_ca_certificate = base64decode(var.eks_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    config_path            = ""
  }
}

provider "kubectl" {
  host                   = var.eks_host
  cluster_ca_certificate = base64decode(var.eks_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}
