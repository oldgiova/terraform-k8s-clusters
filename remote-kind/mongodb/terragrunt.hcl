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
    mongodb-common = {
      namespace = "default"
      type      = "Opaque"
      values = [
        {
          secret_name  = "MONGO"
          secret_value = "mongodb+srv://mender-mongo.default.svc.cluster.local/?tls=false"
        },
        {
          secret_name  = "MONGO_URL"
          secret_value = "mongodb+srv://mender-mongo.default.svc.cluster.local/?tls=false"
        }
      ]

    }
  }

  helm = {
    namespace = {
      create = false
      name   = "default"
    }
    # https://github.com/bitnami/charts/tree/main/bitnami/mongodb
    repo_url            = "https://charts.bitnami.com/bitnami"
    helmrepository_name = "mongodb"
    helmrelease_name    = "mender-mongo"
    chart_name          = "mongodb"
    version             = "14.7.0"
    values = {
      name          = "values-mongo"
      configmap_key = "values-mongo.yaml"
      values_content = templatefile(
        "./values-mongo.yaml",
        {
          image = {
            registry   = "docker.io"
            repository = "mongo"
            tag        = "5.0.24-focal"
          }
          architecture = {
            arbiter_enabled = false
            architecture    = "standalone"
            replicas        = 1
          }
          config = {
            name            = "mender-mongo"
            root_password   = run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/mongodb-test-password")
            replica_set_key = run_cmd("--terragrunt-quiet", "pass", "show", "oldgiova/mender/mongodb-test-password")
            resources = {
              "limits" : {
                "memory" : "2Gi",
                "cpu" : "200m"
              }
              "requests" : {
                "memory" : "128Mi",
                "cpu" : "25m",
              }
            }
            resources_arbiter = {}
            custom_readiness_probe = {
              "exec" : {
                "command" : [
                  "mongo",
                  "--eval",
                  "db.adminCommand('ping')"
                ]
              }
            }
            topology_spread_constraints = {}
            affinity                    = {}
          }
          storage = {
            persistence_enabled    = false
            persistence_name       = "data"
            persistence_mount_path = "/data/db"
            size                   = "8Gi"
            storage_class          = "standard"
          }
        }
      )
    }
  }
}


