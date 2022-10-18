resource "kubernetes_manifest" "namespace_ingress_nginx" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/name"     = "ingress-nginx"
      }
      "name" = "ingress-nginx"
    }
  }
  timeouts {
    create = "2m"
    update = "2m"
    delete = "2m"
  }
  wait {
    fields = {
      "status.phase" = "Active"
    }
  }

}


resource "kubernetes_manifest" "serviceaccount_ingress_nginx_ingress_nginx" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion"                   = "v1"
    "automountServiceAccountToken" = true
    "kind"                         = "ServiceAccount"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx"
      "namespace" = "ingress-nginx"
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_ingress_nginx_ingress_nginx_admission" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx-admission"
      "namespace" = "ingress-nginx"
    }
  }
}

resource "kubernetes_manifest" "role_ingress_nginx_ingress_nginx" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "Role"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx"
      "namespace" = "ingress-nginx"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "namespaces",
        ]
        "verbs" = [
          "get",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "configmaps",
          "pods",
          "secrets",
          "endpoints",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "services",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "networking.k8s.io",
        ]
        "resources" = [
          "ingresses",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "networking.k8s.io",
        ]
        "resources" = [
          "ingresses/status",
        ]
        "verbs" = [
          "update",
        ]
      },
      {
        "apiGroups" = [
          "networking.k8s.io",
        ]
        "resources" = [
          "ingressclasses",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resourceNames" = [
          "ingress-controller-leader",
        ]
        "resources" = [
          "configmaps",
        ]
        "verbs" = [
          "get",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "configmaps",
        ]
        "verbs" = [
          "create",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "events",
        ]
        "verbs" = [
          "create",
          "patch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "role_ingress_nginx_ingress_nginx_admission" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "Role"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx-admission"
      "namespace" = "ingress-nginx"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "secrets",
        ]
        "verbs" = [
          "get",
          "create",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_ingress_nginx" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRole"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/name"     = "ingress-nginx"
        "app.kubernetes.io/part-of"  = "ingress-nginx"
        "app.kubernetes.io/version"  = "1.2.1"
      }
      "name" = "ingress-nginx"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "configmaps",
          "endpoints",
          "nodes",
          "pods",
          "secrets",
          "namespaces",
        ]
        "verbs" = [
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "nodes",
        ]
        "verbs" = [
          "get",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "services",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "networking.k8s.io",
        ]
        "resources" = [
          "ingresses",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "events",
        ]
        "verbs" = [
          "create",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "networking.k8s.io",
        ]
        "resources" = [
          "ingresses/status",
        ]
        "verbs" = [
          "update",
        ]
      },
      {
        "apiGroups" = [
          "networking.k8s.io",
        ]
        "resources" = [
          "ingressclasses",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_ingress_nginx_admission" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRole"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name" = "ingress-nginx-admission"
    }
    "rules" = [
      {
        "apiGroups" = [
          "admissionregistration.k8s.io",
        ]
        "resources" = [
          "validatingwebhookconfigurations",
        ]
        "verbs" = [
          "get",
          "update",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_ingress_nginx_ingress_nginx" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "RoleBinding"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx"
      "namespace" = "ingress-nginx"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind"     = "Role"
      "name"     = "ingress-nginx"
    }
    "subjects" = [
      {
        "kind"      = "ServiceAccount"
        "name"      = "ingress-nginx"
        "namespace" = "ingress-nginx"
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_ingress_nginx_ingress_nginx_admission" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "RoleBinding"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx-admission"
      "namespace" = "ingress-nginx"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind"     = "Role"
      "name"     = "ingress-nginx-admission"
    }
    "subjects" = [
      {
        "kind"      = "ServiceAccount"
        "name"      = "ingress-nginx-admission"
        "namespace" = "ingress-nginx"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_ingress_nginx" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRoleBinding"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance" = "ingress-nginx"
        "app.kubernetes.io/name"     = "ingress-nginx"
        "app.kubernetes.io/part-of"  = "ingress-nginx"
        "app.kubernetes.io/version"  = "1.2.1"
      }
      "name" = "ingress-nginx"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind"     = "ClusterRole"
      "name"     = "ingress-nginx"
    }
    "subjects" = [
      {
        "kind"      = "ServiceAccount"
        "name"      = "ingress-nginx"
        "namespace" = "ingress-nginx"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_ingress_nginx_admission" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRoleBinding"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name" = "ingress-nginx-admission"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind"     = "ClusterRole"
      "name"     = "ingress-nginx-admission"
    }
    "subjects" = [
      {
        "kind"      = "ServiceAccount"
        "name"      = "ingress-nginx-admission"
        "namespace" = "ingress-nginx"
      },
    ]
  }
}

resource "kubernetes_manifest" "configmap_ingress_nginx_ingress_nginx_controller" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "allow-snippet-annotations" = "true"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx-controller"
      "namespace" = "ingress-nginx"
    }
  }
}

resource "kubernetes_manifest" "service_ingress_nginx_ingress_nginx_controller" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx-controller"
      "namespace" = "ingress-nginx"
    }
    "spec" = {
      "ports" = [
        {
          "appProtocol" = "http"
          "name"        = "http"
          "port"        = 80
          "protocol"    = "TCP"
          "targetPort"  = "http"
        },
        {
          "appProtocol" = "https"
          "name"        = "https"
          "port"        = 443
          "protocol"    = "TCP"
          "targetPort"  = "https"
        },
      ]
      "selector" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
      }
      "type" = "NodePort"
    }
  }
}

resource "kubernetes_manifest" "service_ingress_nginx_ingress_nginx_controller_admission" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name"      = "ingress-nginx-controller-admission"
      "namespace" = "ingress-nginx"
    }
    "spec" = {
      "ports" = [
        {
          "appProtocol" = "https"
          "name"        = "https-webhook"
          "port"        = 443
          "targetPort"  = "webhook"
        },
      ]
      "selector" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_job" "ingress_nginx_admission_create" {
  metadata {
    name      = "ingress-nginx-admission-create"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.1"
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-create"

        labels = {
          "app.kubernetes.io/component" = "admission-webhook"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"

          "app.kubernetes.io/part-of" = "ingress-nginx"

          "app.kubernetes.io/version" = "1.2.1"
        }
      }

      spec {
        container {
          name  = "create"
          image = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660"
          args  = ["create", "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc", "--namespace=$(POD_NAMESPACE)", "--secret-name=ingress-nginx-admission"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "OnFailure"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx-admission"

        security_context {
          run_as_user     = 2000
          run_as_non_root = true
          fs_group        = 2000
        }
      }
    }
  }
}


resource "kubernetes_job" "ingress_nginx_admission_patch" {
  depends_on = [
    kubernetes_manifest.namespace_ingress_nginx,
    kubernetes_job.ingress_nginx_admission_create
  ]
  metadata {
    name      = "ingress-nginx-admission-patch"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "admission-webhook"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.1"
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-patch"

        labels = {
          "app.kubernetes.io/component" = "admission-webhook"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"

          "app.kubernetes.io/part-of" = "ingress-nginx"

          "app.kubernetes.io/version" = "1.2.1"
        }
      }

      spec {
        container {
          name  = "patch"
          image = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660"
          args  = ["patch", "--webhook-name=ingress-nginx-admission", "--namespace=$(POD_NAMESPACE)", "--patch-mutating=false", "--secret-name=ingress-nginx-admission", "--patch-failure-policy=Fail"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "OnFailure"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx-admission"

        security_context {
          run_as_user     = 2000
          run_as_non_root = true
          fs_group        = 2000
        }
      }
    }
  }
  timeouts {
    create = "2m"
    update = "2m"
    delete = "2m"
  }
}

resource "kubernetes_deployment" "ingress_nginx_controller" {
  depends_on = [
    kubernetes_manifest.namespace_ingress_nginx,
    kubernetes_job.ingress_nginx_admission_create,
    kubernetes_job.ingress_nginx_admission_patch
  ]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/component" = "controller"

      "app.kubernetes.io/instance" = "ingress-nginx"

      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"

      "app.kubernetes.io/version" = "1.2.1"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller"

        "app.kubernetes.io/instance" = "ingress-nginx"

        "app.kubernetes.io/name" = "ingress-nginx"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "controller"

          "app.kubernetes.io/instance" = "ingress-nginx"

          "app.kubernetes.io/name" = "ingress-nginx"
        }
      }

      spec {
        volume {
          name = "webhook-cert"

          secret {
            secret_name = "ingress-nginx-admission"
          }
        }

        container {
          name  = "controller"
          image = "registry.k8s.io/ingress-nginx/controller:v1.2.1@sha256:5516d103a9c2ecc4f026efbd4b40662ce22dc1f824fb129ed121460aaa5c47f8"
          args  = ["/nginx-ingress-controller", "--election-id=ingress-controller-leader", "--controller-class=k8s.io/ingress-nginx", "--ingress-class=nginx", "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller", "--validating-webhook=:8443", "--validating-webhook-certificate=/usr/local/certificates/cert", "--validating-webhook-key=/usr/local/certificates/key", "--watch-ingress-without-class=true", "--publish-status-address=localhost"]

          port {
            name           = "http"
            host_port      = 80
            container_port = 80
            protocol       = "TCP"
          }

          port {
            name           = "https"
            host_port      = 443
            container_port = 443
            protocol       = "TCP"
          }

          port {
            name           = "webhook"
            container_port = 8443
            protocol       = "TCP"
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }

          resources {
            requests = {
              cpu = "100m"

              memory = "90Mi"
            }
          }

          volume_mount {
            name       = "webhook-cert"
            read_only  = true
            mount_path = "/usr/local/certificates/"
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          lifecycle {
            pre_stop {
              exec {
                command = ["/wait-shutdown"]
              }
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["NET_BIND_SERVICE"]
              drop = ["ALL"]
            }

            run_as_user                = 101
            allow_privilege_escalation = true
          }
        }

        dns_policy = "ClusterFirst"

        node_selector = {
          ingress-ready = "true"

          "kubernetes.io/os" = "linux"
        }

        service_account_name = "ingress-nginx"

        toleration {
          key      = "node-role.kubernetes.io/master"
          operator = "Equal"
          effect   = "NoSchedule"
        }

        toleration {
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Equal"
          effect   = "NoSchedule"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_manifest" "ingressclass_nginx" {
  depends_on = [kubernetes_manifest.namespace_ingress_nginx]
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "IngressClass"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name" = "nginx"
    }
    "spec" = {
      "controller" = "k8s.io/ingress-nginx"
    }
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_ingress_nginx_admission" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "admission-webhook"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
        "app.kubernetes.io/part-of"   = "ingress-nginx"
        "app.kubernetes.io/version"   = "1.2.1"
      }
      "name" = "ingress-nginx-admission"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "ingress-nginx-controller-admission"
            "namespace" = "ingress-nginx"
            "path"      = "/networking/v1/ingresses"
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "validate.nginx.ingress.kubernetes.io"
        "rules" = [
          {
            "apiGroups" = [
              "networking.k8s.io",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "ingresses",
            ]
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}
