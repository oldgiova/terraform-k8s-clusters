variable "k8s" {
  description = <<EOF
Kubernetes authentication context.

endpoint       = Cluster API Endpoint.
ca_certificate = Base64 encoded cluster certificate authority.
token          = Bearer token to authenticate with the cluster.
EOF
  type = object({
    endpoint           = string
    ca_certificate     = string
    client_certificate = optional(string, "")
    client_key         = optional(string, "")
    exec_credentials = optional(object({
      command = string
      args    = list(string)
      env     = optional(map(string), {})
    }))
  })
  sensitive = true
}

variable "fluxcd" {
  description = <<EOF
Flux conf
gitrepository_name: the name of the GitRepository resource
helmrelease_name: the name of the HelmRelease resource
spec_interval: Default Fluxcd interval to check for reconciliation"
EOF
  type = object({
    #namespace          = optional(string, "flux-system")
    gitrepository_name = optional(string, "hm-helm-manifests-gitrepo")
    helmrelease_name   = optional(string, "hostedmender")
    spec_interval      = optional(string, "1m0s")
  })
  default = {}
}


variable "helm" {
  description = <<EOF
Helm values

chart_path: where the helm chart is located inside
            the git repository

version_to_upgrade: Version semver expression - eg ~3.4.0
                    to upgrade every version: *
EOF
  type = object({
    github = object({
      owner           = optional(string, "mendersoftware")
      branch          = optional(string, "master-next")
      repository_name = optional(string, "mender-helm")
      chart_path      = optional(string, "./mender")
      git_secret_name = optional(string, "hm-helm-gitrepo-secret")
      git_secret      = optional(string, "")
      git_user        = optional(string, "")
    })
    values = object({
      name                   = optional(string, "values-demo-env")
      configmap_key          = optional(string, "values-demo.yaml")
      values_content         = optional(string, "")
      helm_repo_values_files = optional(list(string), [])
    })
    version_to_upgrade = optional(string, "*")
    namespace = object({
      name   = optional(string, "alvaldi-demo")
      create = optional(bool, false)
    })
    install = object({
      retries = optional(number, 1)
    })
  })
}

variable "secrets" {
  description = <<EOF
Secrets that can be added to the flux helm environment.
For example regctl secrets

the .metadata.name of the secret is the key of the map

namespace: the namespace where to place the secret
type: k8s secret type (Opaque, kubernetes.io/dockerconfigjson, ...)
values: a list of key/value maps (multiple keys are possible inside the secret)
  secret_name: the key of the secret
  secret_value:  the value of the secret
EOF
  type = map(object({
    #name          = string
    namespace = string
    type      = string
    values = list(object({
      secret_name  = optional(string, "")
      secret_value = string
    }))
  }))
  default = {}
}

variable "alerts" {
  description = <<EOF
Alerts configuration
EOF
  type = object({
    channel  = optional(string, "server-monitoring-dev")
    address  = optional(string, "")
    summary  = optional(string, "Cluster Flux alert")
    severity = optional(string, "info")
  })
  default = {}
}

