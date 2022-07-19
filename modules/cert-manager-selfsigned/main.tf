resource "kubernetes_manifest" "default" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = var.cert_manager_issuer_name
    }
    "spec" = {
      "selfSigned" = {}
    }
  }
}
