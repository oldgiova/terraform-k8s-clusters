resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  version          = "0.20.1"
  namespace        = "vault"
  create_namespace = true

  values = [
    "${file("hashicorp_vault.yaml")}"
  ]
  set {
    name  = "server.affinity"
    value = ""
  }
}

