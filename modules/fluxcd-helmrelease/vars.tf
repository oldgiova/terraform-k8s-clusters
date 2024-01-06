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
