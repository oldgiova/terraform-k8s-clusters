resource "tls_private_key" "deviceauth" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

resource "tls_private_key" "useradm" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

resource "helm_release" "mender" {
  name             = "mender"
  repository       = "https://charts.mender.io"
  chart            = "mender"
  version          = "3.3.0"
  namespace        = var.cluster_type == "production" ? "prod" : var.cluster_type
  create_namespace = true
  values = [
    templatefile("mender-3.3.0.yaml.tfpl",
      {
        mender = {
          mongodb_root_password = var.mongodb_root_password
          minio_domain_name     = var.minio_domain_name
          minio_access_key      = var.minio_access_key
          minio_secret_key      = var.minio_secret_key
          mender_server_domain  = var.mender_server_domain
        }
    })
  ]
  set {
    name  = "device_auth.certs.key"
    value = tls_private_key.deviceauth.private_key_pem
  }
  set {
    name  = "useradm.certs.key"
    value = tls_private_key.useradm.private_key_pem
  }
}

resource "kubernetes_ingress_v1" "mender_ingress" {
  depends_on = [
    helm_release.mender
  ]
  metadata {
    name      = "mender-ingress"
    namespace = "default"
    annotations = {
      "cert-manager.io/issuer" = "letsencrypt"
    }
  }
  spec {
    tls {
      secret_name = "mender-ingress-tls"
      hosts       = [var.mender_server_domain]
    }

    rule {
      host = var.mender_server_domain
      http {
        path {
          path_type = "Prefix"
          backend {
            service {
              name = "mender-api-gateway"
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


