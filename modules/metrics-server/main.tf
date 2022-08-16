resource "helm_release" "metrics-server" {
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = "3.8.2"
  namespace        = "kube-system"
  create_namespace = true
  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}
