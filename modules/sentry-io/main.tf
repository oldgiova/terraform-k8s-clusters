resource "helm_release" "sentry" {
  chart             = "sentry"
  name              = "sentry"
  repository        = "https://sentry-kubernetes.github.io/charts"
  namespace         = "monitoring"
  create_namespace  = true
  version           = var.sentry_helm_version
  timeout           = 600
  wait              = true
  dependency_update = true
  values = [
    file("values_sentry.${var.sentry_helm_version}.yaml")
  ]
  set {
    name  = "ingress.enabled"
    value = "true"
  }
}
