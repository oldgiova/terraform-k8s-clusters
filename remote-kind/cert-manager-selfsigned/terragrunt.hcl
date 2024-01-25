include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../modules//cert-manager-selfsigned"
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

dependency "cert-manager-crd" {
  config_path  = "../cert-manager-crd"
  skip_outputs = true
}

inputs = {
  k8s = {
    endpoint           = "https://${include.root.inputs.kubernetes_host}:6443"
    ca_certificate     = dependency.k8s_cluster.outputs.cluster_ca_certificate
    client_key         = dependency.k8s_cluster.outputs.client_key_enc
    client_certificate = dependency.k8s_cluster.outputs.client_certificate_enc
  }

  cert_manager_issuer_name = "selfsigned-cluster-issuer"
}

