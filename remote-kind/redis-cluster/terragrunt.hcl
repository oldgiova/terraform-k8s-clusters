include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  #source = "git::https://github.com/NorthernTechHQ/nt-iac.git//modules/k8s/redis-cluster?ref=k8s-v1.0"
    #source = "git::https://github.com/NorthernTechHQ/nt-iac.git//modules/k8s/redis-cluster?depth=1&ref=k8s-v1.0"
  source = "/home/giova/src/github/northerntechhq/worktrees/nt-iac/main//modules//k8s/redis-cluster"
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
  helm_version = "9.2.1"

  service = {
    annotations = {
      "service.kubernetes.io/topology-aware-hints" = "auto"
    }
  }

  redis = {
    resources = {
      "limits" : {
        "memory" : "200Mi",
        "cpu" : "200m"
      }
      "requests" : {
        "memory" : "200Mi",
        "cpu" : "200m",
      }
    }
    password     = ""
  }

  cluster = {
    nodes    = 3
    replicas = 0
  }

}
