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
    rsa-device-auth = {
      namespace = "default"
      type      = "Opaque"
      values = [
        {
          secret_name  = "private.pem"
          secret_value = run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/device_auth_test.key")
        }
      ]
    }
    rsa-tenantadm = {
      namespace = "default"
      type      = "Opaque"
      values = [
        {
          secret_name  = "private.pem"
          secret_value = run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/tenantadm_test.key")
        }
      ]
    }
    rsa-useradm = {
      namespace = "default"
      type      = "Opaque"
      values = [
        {
          secret_name  = "private.pem"
          secret_value = run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/useradm_test.key")
        }
      ]
    }
  }

  helm = {
    namespace = {
      create = false
      name   = "default"
    }
    repo_url            = "https://charts.mender.io"
    helmrepository_name = "mender"
    helmrelease_name    = "mender"
    chart_name          = "mender"
    version             = "5.4.1"
    values = {
      name          = "mender-values"
      configmap_key = "values-mender.yaml"
      values_content = templatefile(
        "./values-mender.yaml",
        {
          config = {
            username        = get_env("REGISTRY_MENDER_IO_USERNAME")
            password        = get_env("REGISTRY_MENDER_IO_PASSWORD")
            minio_accesskey = get_env("MINIO_ACCESS_KEY")
            minio_secretkey = get_env("MINIO_SECRET_KEY")
          }
        }
      )
    }
  }
}


