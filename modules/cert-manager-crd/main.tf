
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.8.2"
  # values = [
  #  "${file(cert_manager_values.yaml)}"
  # ]
  namespace        = "cert-manager"
  create_namespace = true
  set {
    name  = "prometheus.enabled"
    value = "false"
  }
  set {
    name  = "featureGates"
    value = "ExperimentalCertificateSigningRequestControllers=true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

