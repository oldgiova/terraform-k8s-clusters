resource "helm_release" "prometheus_stack" {
  chart            = "kube-prometheus-stack"
  name             = "kube-prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "monitoring"
  create_namespace = true
  version          = "33.2.0"
  recreate_pods    = true
  timeout          = 120
  values = [
    file("prometheus.yaml")
  ]
  #  set {
  #    name = "grafana.ingress.enabled"
  #    value = "true"
  #  }
  #  set {
  #    name = "grafana.ingress.hosts[0]"
  #    value = "grafana.example.org"
  #  }
}
