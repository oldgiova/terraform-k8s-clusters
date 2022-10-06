


# Helm repo: https://github.com/grafana/helm-charts/tree/loki-simple-scalable-1.8.11
resource "helm_release" "grafana_oncall" {
  chart            = "loki-simple-scalable"
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = "monitoring"
  create_namespace = true
  version          = var.loki_chart_version
  recreate_pods    = true
  timeout          = 300
  values = [
    file("grafana_loki_simple_scalable_values_${var.loki_chart_version}.yaml")
  ]
  set {
    name = "loki.storage.s3.s3"
    value = var.loki_s3_url
  }
  set {
    name = "loki.storage.s3.endpoint"
  }
}

