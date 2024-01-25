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

  secrets = {
    minio-creds-secret = {
      namespace = "default"
      type      = "Opaque"
      values = [
        {
          secret_name  = "accesskey"
          secret_value = get_env("MINIO_ACCESS_KEY")
        },
        {
          secret_name  = "secretkey"
          secret_value = get_env("MINIO_SECRET_KEY")
        }
      ]
    }
  }
  helm = {
    namespace = {
      create = false
      name   = "default"
    }
    repo_url            = "https://operator.min.io/"
    helmrepository_name = "minio"
    helmrelease_name    = "minio"
    chart_name          = "minio-operator"
    version             = "4.1.7"
    values = {
      name           = "minio-values"
      configmap_key  = "values-minio.yaml"
      values_content = <<EOS
tenants: {}
EOS
    }
  }
}


