include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//grafana-oncall"
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

dependency "cert_manager" {
  config_path = "../cert-manager-selfsigned"
  mock_outputs = {
    cert_manager_selfsigned_issuer_name = "dummy"
  }

}

inputs = {
  kubernetes_host                   = "https://127.0.0.1:6443"
  kubernetes_client_certificate     = dependency.k8s_cluster.outputs.client_certificate
  kubernetes_client_key             = dependency.k8s_cluster.outputs.client_key
  kubernetes_cluster_ca_certificate = dependency.k8s_cluster.outputs.cluster_ca_certificate

  oncall_cert_manager_enabled = false
  oncall_ingress_nginx_enabled = false
  oncall_mariadb_enabled = true
}

