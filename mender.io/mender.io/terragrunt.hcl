include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//mender.io"
}

dependency "k8s_cluster" {
  config_path = "../kind"
  mock_outputs = {
    endpoint               = "dummy"
    client_certificate     = "dummy"
    client_key             = "dummy"
    cluster_ca_certificate = "dummy"
  }
}

dependency "prometheus-stack" {
  config_path  = "../prometheus-stack"
  skip_outputs = true
}

dependency "cert-manager-crd" {
  config_path  = "../cert-manager-crd"
  skip_outputs = true
}

dependency "ingress" {
  config_path  = "../ingress"
  skip_outputs = true
}

dependency "nats" {
  config_path  = "../nats"
  skip_outputs = true
}

dependency "minio" {
  config_path = "../minio"
  mock_outputs = {
    minio_access_key = "dummy"
    minio_secret_key = "dummy"
  }
}

dependency "mongodb" {
  config_path = "../mongodb"
  mock_outputs = {
    mongodb_root_password = "dummy"
  }
}

inputs = {
  kubernetes_host                   = "https://127.0.0.1:6443"
  kubernetes_client_certificate     = dependency.k8s_cluster.outputs.client_certificate
  kubernetes_client_key             = dependency.k8s_cluster.outputs.client_key
  kubernetes_cluster_ca_certificate = dependency.k8s_cluster.outputs.cluster_ca_certificate

  mongodb_root_password = dependency.mongodb.outputs.mongodb_root_password
  minio_domain_name     = "minio"
  minio_access_key      = dependency.minio.outputs.minio_access_key
  minio_secret_key      = dependency.minio.outputs.minio_secret_key

  mender_server_domain = "mender.example.org"

}

