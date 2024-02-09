resource "random_string" "minio_access_key" {
  length  = 16
  special = false
}

resource "random_password" "minio_secret_key" {
  length  = 20
  special = false
}

resource "helm_release" "minio_operator" {
  depends_on = [
    random_string.minio_access_key,
    random_password.minio_secret_key
  ]
  name             = "minio-operator"
  repository       = "https://operator.min.io/"
  chart            = "minio-operator"
  version          = "4.1.7"
  namespace        = var.cluster_type == "production" ? "prod" : var.cluster_type
  create_namespace = true
  values = [
    file("minio_operator.yaml")
  ]
}

resource "kubernetes_secret_v1" "minio-creds-secret" {
  metadata {
    name      = "minio-creds-secret"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    accesskey = random_string.minio_access_key.result
    secretkey = random_password.minio_secret_key.result
  }

  type = "Opaque"
}

resource "kubernetes_ingress_v1" "minio_ingress" {
  metadata {
    name      = "minio-ingress"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }
  spec {
    # tls {
    #   secret_name = "ingress-hm-certs"
    #   hosts       = [var.minio_domain]
    # }

    rule {
      host = var.minio_domain
      http {
        path {
          path_type = "Prefix"
          backend {
            service {
              name = "minio"
              port {
                number = 80
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}


