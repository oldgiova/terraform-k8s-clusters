resource "helm_release" "consul" {
  name             = "consul"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "consul"
  version          = "0.43.0"
  namespace        = "vault"
  create_namespace = true

  set {
    name  = "global.name"
    value = "consul"
  }
}

