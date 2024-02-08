include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "/home/giova/src/github/mendersoftware/saas/terragrunt//modules/k8s/nats"
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


inputs = {
  k8s = {
    endpoint           = "https://${include.root.inputs.kubernetes_host}:6443"
    ca_certificate     = dependency.k8s_cluster.outputs.cluster_ca_certificate
    client_key         = dependency.k8s_cluster.outputs.client_key_enc
    client_certificate = dependency.k8s_cluster.outputs.client_certificate_enc
  }

  namespace    = "default"
  helm_version = "0.19.17"

  image = {
    repository = "nats"
    tag        = "2.9.24-scratch"
    pullPolicy = "IfNotPresent"
    registry   = "docker.io"
  }

  name = "mender-nats"

  jetstream = {
    memory = "1Gi"
    file   = "20Gi"
  }
  resources = {
    "limits" : {
      "cpu" : "500m", "memory" : "1Gi"
    },
    "requests" : {
      "cpu" : "100m", "memory" : "256Mi"
    }
  }
  replicas = 3
  monitoring = {
    enabled   = true
    namespace = "monitoring"
    image_tag = "0.12.0"
    resources = {
      "limits" : { "cpu" : "20m", "memory" : "96Mi" }
      "requests" : { "cpu" : "10m", "memory" : "48Mi" }
    }
  }
}
