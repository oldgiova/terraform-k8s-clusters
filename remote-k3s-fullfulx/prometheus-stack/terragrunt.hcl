include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//fluxcd-helmrelease"
}

dependency "flux" {
  config_path  = "../fluxcd"
  skip_outputs = true
}

inputs = {
  helm = {
    namespace = {
      create = true
      name   = "monitoring"
    }
    repo_url            = "https://prometheus-community.github.io/helm-charts"
    helmrepository_name = "prometheus"
    helmrelease_name    = "prometheus"
    chart_name          = "kube-prometheus-stack"
    version             = "55.6.0"
    values = {
      name           = "values-prometheus"
      configmap_key  = "values-prometheus.yaml"
      values_content = <<EOF
EOF
    }
  }
}

