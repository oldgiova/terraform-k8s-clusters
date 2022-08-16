include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//cert-manager-route53"
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
  kubernetes_host                   = "https://127.0.0.1:6443"
  kubernetes_client_certificate     = dependency.k8s_cluster.outputs.client_certificate
  kubernetes_client_key             = dependency.k8s_cluster.outputs.client_key
  kubernetes_cluster_ca_certificate = dependency.k8s_cluster.outputs.cluster_ca_certificate
  aws_route53_user_name             = "route53-user"
}

