include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git::https://github.com/NorthernTechHQ/nt-iac.git//modules/k8s/fluxcd-helmrelease-gitrepository?depth=1&ref=k8s-v1.0"
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

dependency "redis" {
  config_path = "../redis-cluster"
  mock_outputs = {
    redis_connection_string = "placeholder"
  }
}

dependency "cert_manager" {
  config_path = "../cert-manager-route53"
  mock_outputs = {
    issuer_name = "placeholder"
  }
}


inputs = {
  k8s = {
    endpoint           = "https://${include.root.inputs.kubernetes_host}:6443"
    ca_certificate     = dependency.k8s_cluster.outputs.cluster_ca_certificate
    client_key         = dependency.k8s_cluster.outputs.client_key_enc
    client_certificate = dependency.k8s_cluster.outputs.client_certificate_enc
  }

  fluxcd = {
    gitrepository_name = "mender-helm-manifests-gitrepo"
    helmrelease_name   = "mender"
  }

  alerts = {
    channel  = "server-monitoring-dev"
    address  = run_cmd("--terragrunt-quiet", "pass", "mender/saas/terraform/slack/slack-notification-webhook-staging")
    summary  = "roberto test fluxcd alert"
    severity = "info"
  }

  secrets = {
    rsa-device-auth = {
      namespace = "default"
      type      = "Opaque"
      values = {
        "private.pem" : run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/device_auth_test.key")
      }
    }
    rsa-tenantadm = {
      namespace = "default"
      type      = "Opaque"
      values = {
        "private.pem" = run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/tenantadm_test.key")
      }
    }
    rsa-useradm = {
      namespace = "default"
      type      = "Opaque"
      values = {
        "private.pem" = run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/useradm_test.key")
      }
    }
  }

  helm = {
    # Github properties
    github = {
      #owner           = "mendersoftware"
      owner           = "oldgiova"
      #branch          = "staging"
      branch          = "MC-6856-host-header"
      repository_name = "mender-helm"
      chart_path      = "./mender"
      git_secret_name = "github-repo-token-secret"
      git_secret      = run_cmd("--terragrunt-quiet", "pass", "mender/saas/k8s/bot_github_token")
      git_user        = "bot-northerntech"
    }

    # namespace where to install the helm chart, 
    # and the Flux resources for this setup,
    # and an optional registry secret
    namespace = {
      create                  = false
      name                    = "default"
      registry_secret_enabled = true
      registry_secret_name    = "registry-mender-io-secret"
      registry_secret         = run_cmd("--terragrunt-quiet", "../../../../mendersoftware/saas/terragrunt/.scripts/pass_secret_certificate.sh", "mender/saas/k8s/secret-registry-mender-io-secret.yaml", ".dockerconfigjson")

    }

    install = {
      retries = 0
    }

    values = {
      #helm_repo_values_files = ["mender/values.yaml", "mender/values-staging.yaml"]
      helm_repo_values_files = ["mender/values.yaml"]
      name                   = "mender-values"
      configmap_key          = "values-mender-staging.yaml"
      values_content = templatefile(
        "./values-mender.yaml",
        {
          config = {
            username        = get_env("REGISTRY_MENDER_IO_USERNAME")
            password        = get_env("REGISTRY_MENDER_IO_PASSWORD")
            minio_accesskey = get_env("MINIO_ACCESS_KEY")
            minio_secretkey = get_env("MINIO_SECRET_KEY")
            issuer_name     = dependency.cert_manager.outputs.issuer_name
            redis_secret    = "redis-connection-string"
          }
        }
      )
    }
  }
}
