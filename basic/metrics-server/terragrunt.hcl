include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../modules//fluxcd-helmrelease"
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

  helm = {
    namespace = {
      create = false
      name   = "kube-system"
    }
    # https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server
    repo_url            = "https://kubernetes-sigs.github.io/metrics-server"
    helmrepository_name = "metrics-server"
    helmrelease_name    = "metrics-server"
    chart_name          = "metrics-server"
    version             = "3.8.2"
    values = {
      name           = "values-metrics-server"
      configmap_key  = "values-metrics-server.yaml"
      values_content = <<EOF
args:
  - --kubelet-insecure-tls
EOF
    }
  }
}


