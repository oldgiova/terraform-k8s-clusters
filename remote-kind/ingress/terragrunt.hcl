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
      name   = "ingress-nginx"
    }
    # https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/Chart.yaml
    repo_url            = "https://kubernetes.github.io/ingress-nginx"
    helmrepository_name = "ingress-nginx"
    helmrelease_name    = "ingress-nginx"
    chart_name          = "ingress-nginx"
    version             = "4.9.0"
    values = {
      name           = "ingress-nginx-values"
      configmap_key  = "values-ingress-nginx.yaml"
      values_content = <<EOS
controller:
  ingressClassResource:
    name: nginx
    enabled: true
    default: true
  resources:
    limits:
      cpu: 200m
      memory: 200Mi
    requests:
      cpu: 50m
      memory: 90Mi
EOS
    }
  }
}
