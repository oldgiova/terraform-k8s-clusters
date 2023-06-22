variable "eks_cluster_id" {
  description = "EKS Cluster id"
  type        = string
}

variable "eks_host" {
  description = "EKS Host"
  type        = string
}

variable "eks_certificate_authority_data" {
  description = "EKS Host"
  type        = string
}

variable "fluxcd" {
  description = <<EOF
Flux conf
gitrepository_name: the name of the GitRepository resource
helmrelease_name: the name of the HelmRelease resource
spec_interval: Default Fluxcd interval to check for reconciliation"
EOF
  type = object({
    namespace          = optional(string, "flux-system")
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
      name           = optional(string, "values-demo-env")
      configmap_key  = optional(string, "values-demo.yaml")
      values_content = optional(string, "")
    })
    version_to_upgrade = optional(string, "*")
    namespace = object({
      name   = optional(string, "alvaldi-demo")
      create = optional(bool, false)
    })
  })
}
