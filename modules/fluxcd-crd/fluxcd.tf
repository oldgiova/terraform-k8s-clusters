#
# main
#
resource "kubernetes_namespace" "flux_system" {
  count = var.fluxcd.enabled ? 1 : 0
  metadata {
    name = "flux-system"
  }
}

resource "helm_release" "fluxcd" {
  depends_on = [
    kubernetes_namespace.flux_system
  ]
  count            = var.fluxcd.enabled ? 1 : 0
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = true
  version          = var.fluxcd.helm_version
  values = [
    <<-EOF
    helmController:
      resources:
        limits:
          cpu: 1000m
          memory: 1Gi
    imageAutomationController:
      resources:
        limits:
          cpu: 1000m
          memory: 1Gi
    imageReflectionController:
      resources:
        limits:
          cpu: 1000m
          memory: 1Gi
    kustomizeController:
      resources:
        limits:
          cpu: 1000m
          memory: 1Gi
    notificationController:
      resources:
        limits:
          cpu: 1000m
          memory: 1Gi
    sourceController:
      resources:
        limits:
          cpu: 1000m
          memory: 1Gi
    EOF
  ]
}
