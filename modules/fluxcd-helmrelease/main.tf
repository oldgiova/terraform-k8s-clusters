# Optionally create the Namespace for both the
# Flux resources and the Helm deployment
# itself
resource "kubernetes_namespace" "helm_deployment" {
  count = var.helm.namespace.create ? 1 : 0
  metadata {
    name = var.helm.namespace.name
  }
}

# Define the Helm repo to watch
resource "kubectl_manifest" "flux_helmrepository" {
  yaml_body = <<YAML
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: ${var.helm.helmrepository_name}
  namespace: ${var.helm.namespace.name}
spec:
  interval: ${var.helm.spec_interval}
  url: ${var.helm.repo_url}
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
  name: ${var.helm.helmrelease_name}
  namespace: ${var.helm.namespace.name}
spec:
  interval: ${var.helm.spec_interval}
  chart:
    spec:
      chart: ${var.helm.chart_name}
      version: "${var.helm.version}"
      sourceRef:
        kind: "HelmRepository"
        name: ${var.helm.helmrepository_name}
        namespace: ${var.helm.namespace.name}
      upgrade:
        cleanupOnFail: true
        remediation:
          ignoreTestFailures: false
          remediateLastFailure: true
          retries: 0
          strategy: "rollback"
      releaseName: ${var.helm.helmrelease_name}
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
