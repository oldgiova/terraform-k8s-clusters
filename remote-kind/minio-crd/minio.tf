resource "kubernetes_manifest" "tenant_minio" {
  depends_on = [kubectl_manifest.flux_helmrelease]
  manifest = {
    "apiVersion" = "minio.min.io/v2"
    "kind"       = "Tenant"
    "metadata" = {
      "labels" = {
        "app" = "minio"
      }
      "name"      = "minio"
      "namespace" = var.helm.namespace.name
    }
    "spec" = {
      "credsSecret" = {
        "name" = "minio-creds-secret"
      }
      "image"     = "minio/minio:RELEASE.2021-06-17T00-10-46Z"
      "mountPath" = "/export"
      "pools" = [
        {
          "servers" = 2
          "volumeClaimTemplate" = {
            "metadata" = {
              "name" = "data"
            }
            "spec" = {
              "accessModes" = [
                "ReadWriteOnce",
              ]
              "resources" = {
                "requests" = {
                  "storage" = "10Gi"
                }
              }
              "storageClassName" = "standard"
            }
          }
          "volumesPerServer" = 2
        },
      ]
      "requestAutoCert" = false
    }
  }
}
