include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../modules//ingress_nginx"
}

dependency "flux" {
  config_path  = "../fluxcd"
  skip_outputs = true
}

dependency "k8s_cluster" {
  config_path = "../kind"
  mock_outputs = {
    endpoint                     = "dummy"
    client_certificate           = "dummy"
    client_key                   = "dummy"
    cluster_ca_certificate_plain = "dummy"
  }
}

inputs = {
  k8s = {
    endpoint           = "https://${include.root.inputs.kubernetes_host}:6443"
    ca_certificate     = dependency.k8s_cluster.outputs.cluster_ca_certificate
    client_key         = dependency.k8s_cluster.outputs.client_key_enc
    client_certificate = dependency.k8s_cluster.outputs.client_certificate_enc
  }
}
