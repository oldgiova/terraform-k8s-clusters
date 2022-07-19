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
  namespace        = "default"
  create_namespace = true
  values = [
    file("minio_operator.yaml")
  ]
}

resource "kubernetes_secret_v1" "minio-creds-secret" {
  metadata {
    name      = "minio-creds-secret"
    namespace = "default"
  }

  data = {
    accesskey = random_string.minio_access_key.result
    secretkey = random_password.minio_secret_key.result
  }

  type = "Opaque"
}

resource "kubectl_manifest" "tenant_minio" {
  depends_on = [
    helm_release.minio_operator
  ]
  override_namespace = "default"
  yaml_body          = <<YAML
apiVersion: minio.min.io/v2
kind: Tenant
metadata:
  name: minio
  labels:
    app: minio
spec:
  image: minio/minio:RELEASE.2021-06-17T00-10-46Z
  credsSecret:
    name: minio-creds-secret
  pools:
    - servers: 2
      volumesPerServer: 2
      volumeClaimTemplate:
        metadata:
          name: data
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 10Gi
          storageClassName: "standard"
  mountPath: /export
  requestAutoCert: false
YAML
}

resource "kubernetes_ingress_v1" "minio_ingress" {
  metadata {
    name      = "minio-ingress"
    namespace = "default"
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


