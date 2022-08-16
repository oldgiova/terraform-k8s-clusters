resource "helm_release" "nats" {
  name             = "nats"
  repository       = "https://nats-io.github.io/k8s/helm/charts/"
  chart            = "nats"
  version          = "0.8.2"
  namespace        = var.cluster_type == "production" ? "prod" : var.cluster_type
  create_namespace = true
  timeout          = 120
  values = [
    file("nats.yaml")
  ]
}

