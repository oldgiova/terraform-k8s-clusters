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
      create = true
      name   = "monitoring"
    }
    # https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
    repo_url            = "https://prometheus-community.github.io/helm-charts"
    helmrepository_name = "kube-prometheus"
    helmrelease_name    = "kube-prometheus"
    chart_name          = "kube-prometheus-stack"
    version             = "56.0.3"
    values = {
      name          = "kube-prometheus"
      configmap_key = "values-kube-prometheus.yaml"
      values_content = templatefile(
        "./values-kube-prometheus.yaml",
        {
          config = {
            prometheus_storage_class_name = "standard"
            alertmanager_storage_size     = "10"
            grafana_image_tag             = ""
            enable_grafana_ingress        = false
            prometheus_metrics_retention  = "30h"
            prometheus_storage_size       = "10"
          }
        }
      )
    }
  }
}


