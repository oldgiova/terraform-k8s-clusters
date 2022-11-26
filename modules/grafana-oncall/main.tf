resource "kubernetes_manifest" "cert_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Issuer"
    "metadata" = {
      "name"      = var.oncall_cert_manager_issuer_name
      "namespace" = "monitoring"
    }
    "spec" = {
      "selfSigned" = {}
    }
  }
}

# Helm repo: https://github.com/grafana/oncall/tree/v1.0.36/helm/oncall
resource "helm_release" "grafana_oncall" {
  chart            = "oncall"
  name             = "oncall"
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = "monitoring"
  create_namespace = true
  version          = "1.0.5"
  recreate_pods    = true
  timeout          = 300
  values = [
    file("grafanaoncall_values_1.0.5.yaml")
  ]
  set {
    name  = "base_url"
    value = var.oncall_base_url
  }
  set {
    name  = "engine.replicaCount"
    value = var.oncall_engine_replica_count
  }
  set {
    name  = "celery.replicaCount"
    value = var.oncall_celery_replica_count
  }
  set {
    name  = "oncall.slack.enabled"
    value = var.oncall_slack_enabled
  }
  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = var.oncall_ingress_annotations_ingress_class
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/issuer"
    value = var.oncall_cert_manager_issuer_name
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = var.oncall_ingress_secretName
  }
  set {
    name  = "ingress-nginx.enabled"
    value = var.oncall_ingress_nginx_enabled
  }
  set {
    name  = "cert-manager.enabled"
    value = var.oncall_cert_manager_enabled
  }
  set {
    name  = "mariadb.enabled"
    value = var.oncall_mariadb_enabled
  }
  set {
    name  = "externalMysql.host"
    value = var.oncall_externalmmsql_host
  }
  set {
    name  = "externalMysql.port"
    value = var.oncall_externalmmsql_port
  }
  set {
    name  = "externalMysql.db_name"
    value = var.oncall_externalmmsql_db_name
  }
  set {
    name  = "externalMysql.user"
    value = var.oncall_externalmmsql_user
  }
  # set {
  #   name = "externalMysql.password"
  #   value = var.oncall_externalmmsql_password
  # }
  set {
    name  = "grafana.enabled"
    value = var.oncall_grafana_enabled
  }
}

