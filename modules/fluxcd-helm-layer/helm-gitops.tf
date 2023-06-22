# Optionally create the Namespace for both the
# Flux resources and the Helm deployment
# itself
resource "kubernetes_namespace" "helm_deployment" {
  count = var.helm.namespace.create ? 1 : 0
  metadata {
    name = var.helm.namespace.name
  }
}

# Secret for accessing to private Github repos
resource "kubernetes_secret_v1" "fluxcd_gitrepo_secret" {
  metadata {
    name      = var.helm.github.git_secret_name
    namespace = var.helm.namespace.name
  }
  data = {
    "username" = var.helm.github.git_user
    "password" = var.helm.github.git_secret

  }
  type = "Opaque"
}

# Flux for Mender.io/Alvaldi/other

# Define the Helm repo to watch
resource "kubectl_manifest" "flux_gitrepository" {
  yaml_body = <<YAML
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: ${var.fluxcd.gitrepository_name}
  namespace: ${var.helm.namespace.name}
spec:
  interval: ${var.fluxcd.spec_interval}
  ref:
    branch: ${var.helm.github.branch}
  url: "https://github.com/${var.helm.github.owner}/${var.helm.github.repository_name}"
  secretRef:
    name: ${var.helm.github.git_secret_name}
YAML
}

# Create a custom Values file maintained by terraform
resource "kubernetes_config_map_v1" "values" {
  metadata {
    name      = var.helm.values.name
    namespace = var.helm.namespace.name
  }

  data = {
    "${var.helm.values.configmap_key}" = var.helm.values.values_content
  }
}

# Create the HelmRelease resource to deploy the
# Helm Chart
resource "kubectl_manifest" "flux_helmrelease" {
  yaml_body = <<YAML
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: ${var.fluxcd.helmrelease_name}
  namespace: ${var.helm.namespace.name}
spec:
  interval: ${var.fluxcd.spec_interval}
  chart:
    spec:
      chart: ${var.helm.github.chart_path}
      version: "${var.helm.version_to_upgrade}"
      sourceRef:
        kind: "GitRepository"
        name: ${var.fluxcd.gitrepository_name}
        namespace: ${var.helm.namespace.name}
      upgrade:
        cleanupOnFail: true
        remediation:
          ignoreTestFailures: false
          remediateLastFailure: true
          retries: 0
          strategy: "rollback"
      releaseName: ${var.fluxcd.helmrelease_name}
      targetNamespace: ${var.helm.namespace.name}
      install:
        createNamespace: true
        remediation:
          ignoreTestFailures: false
          remediateLastFailure: true
          retries: 0
  valuesFrom:
  - kind: "ConfigMap"
    name: ${var.helm.values.name}
    valuesKey: ${var.helm.values.configmap_key}
YAML
}
