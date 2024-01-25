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

variable "helm" {
  description = <<EOF
Helm values

chart_path: where the helm chart is located inside
            the git repository

version_to_upgrade: Version semver expression - eg ~3.4.0
                    to upgrade every version: *
EOF
  type = object({
    values = object({
      name           = optional(string, "values-demo-env")
      configmap_key  = optional(string, "values-demo.yaml")
      values_content = optional(string, "")
    })
    version_to_upgrade = optional(string, "*")
    namespace = object({
      name   = optional(string, "alvaldi-demo")
      create = optional(bool, false)
    })
    repo_url            = optional(string, "")
    version             = optional(string, "")
    chart_name          = optional(string, "")
    spec_interval       = optional(string, "1m0s")
    helmrepository_name = optional(string, "hm-helm-manifests-gitrepo")
    helmrelease_name    = optional(string, "hostedmender")
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
