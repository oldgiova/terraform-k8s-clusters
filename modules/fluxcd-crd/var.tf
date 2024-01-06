#
# variables
# 
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

