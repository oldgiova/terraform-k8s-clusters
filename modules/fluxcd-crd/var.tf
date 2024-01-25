#
# variables
# 
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
Fluxcd configuration
EOF
  type = object({
    enabled = optional(bool, false)
    # https://github.com/fluxcd-community/helm-charts/tree/flux2-2.8.0/charts/flux2
    helm_version = optional(string, "2.8.0")
  })
  default = {}
}

