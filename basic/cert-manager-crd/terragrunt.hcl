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
      name   = "cert-manager"
    }
    # https://artifacthub.io/packages/helm/cert-manager/cert-manager
    repo_url            = "https://charts.jetstack.io"
    helmrepository_name = "cert-manager"
    helmrelease_name    = "cert-manager"
    chart_name          = "cert-manager"
    version             = "v1.13.3"
    values = {
      name           = "cert-manager-values"
      configmap_key  = "values-cert-manager.yaml"
      values_content = <<EOS
prometheus:
  enabled: false

installCRDs: true

featureGates: "ExperimentalCertificateSigningRequestControllers=true"

EOS
    }
  }
}


