output "cert_manager_selfsigned_issuer_name" {
  value = kubernetes_manifest.default.manifest.metadata.name
}
