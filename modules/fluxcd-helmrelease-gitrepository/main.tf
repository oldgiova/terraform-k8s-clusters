# Optionally create the Namespace for both the
# Flux resources and the Helm deployment
# itself
resource "kubernetes_namespace" "helm_deployment" {
  count = var.helm.namespace.create ? 1 : 0
  metadata {
    name = var.helm.namespace.name
  }
}

# Secret for accessing to private Github repos
resource "kubernetes_secret_v1" "fluxcd_gitrepo_secret" {
  metadata {
    name      = var.helm.github.git_secret_name
    namespace = var.helm.namespace.name
  }
  data = {
    "username" = var.helm.github.git_user
    "password" = var.helm.github.git_secret

  }
  type = "Opaque"
}

# Flux for Mender.io/Alvaldi/other
# Define the Helm repo to watch
resource "kubernetes_manifest" "flux_gitrepository" {
  manifest = {
    apiVersion = "source.toolkit.fluxcd.io/v1"
    kind       = "GitRepository"
    metadata = {
      name      = var.fluxcd.gitrepository_name
      namespace = var.helm.namespace.name
    }
    spec = {
      interval = var.fluxcd.spec_interval
      ref = {
        branch = var.helm.github.branch
      }

      url = "https://github.com/${var.helm.github.owner}/${var.helm.github.repository_name}"

      secretRef = {
        name = kubernetes_secret_v1.fluxcd_gitrepo_secret.metadata[0].name
      }
    }
  }
}

#resource "kubectl_manifest" "flux_gitrepository" {
#  yaml_body = <<YAML
#apiVersion: source.toolkit.fluxcd.io/v1beta2
#kind: GitRepository
#metadata:
#  name: ${var.fluxcd.gitrepository_name}
#  namespace: ${var.helm.namespace.name}
#spec:
#  interval: ${var.fluxcd.spec_interval}
#  ref:
#    branch: ${var.helm.github.branch}
#  url: "https://github.com/${var.helm.github.owner}/${var.helm.github.repository_name}"
#  secretRef:
#    name: ${var.helm.github.git_secret_name}
#YAML
#}

# Create a custom Values file maintained by terraform
resource "kubernetes_config_map_v1" "values" {
  metadata {
    name      = var.helm.values.name
    namespace = var.helm.namespace.name
  }

  data = {
    "${var.helm.values.configmap_key}" = var.helm.values.values_content
  }
}

# Create the HelmRelease resource to deploy the
# Helm Chart
resource "kubernetes_manifest" "flux_helmrelease" {
  manifest = {
    apiVersion = "helm.toolkit.fluxcd.io/v2beta2"
    kind       = "HelmRelease"
    metadata = {
      name      = var.fluxcd.helmrelease_name
      namespace = var.helm.namespace.name
    }
    spec = {
      interval = var.fluxcd.spec_interval
      chart = {
        spec = {
          chart   = var.helm.github.chart_path
          version = var.helm.version_to_upgrade
          sourceRef = {
            kind      = "GitRepository"
            name      = var.fluxcd.gitrepository_name
            namespace = var.helm.namespace.name
          }
          valuesFiles = var.helm.values.helm_repo_values_files
        }
      }
      valuesFrom = [{
        kind      = "ConfigMap"
        name      = var.helm.values.name
        valuesKey = var.helm.values.configmap_key
      }]
      targetNamespace = var.helm.namespace.name
      releaseName     = var.fluxcd.helmrelease_name
      install = {
        createNamespace = var.helm.namespace.create
        remediation = {
          ignoreTestFailures   = false
          remediateLastFailure = true
          retries              = var.helm.install.retries
        }
      }
      upgrade = {
        cleanupOnFail = true
        remediation = {
          ignoreTestFailures   = false
          remediateLastFailure = true
          retries              = 0
          strategy             = "rollback"
        }
      }
    }
  }
}

#resource "kubectl_manifest" "flux_helmrelease" {
#  yaml_body = <<YAML
#apiVersion: helm.toolkit.fluxcd.io/v2beta1
#kind: HelmRelease
#metadata:
#  name: ${var.fluxcd.helmrelease_name}
#  namespace: ${var.helm.namespace.name}
#spec:
#  interval: ${var.fluxcd.spec_interval}
#  chart:
#    spec:
#      chart: ${var.helm.github.chart_path}
#      version: "${var.helm.version_to_upgrade}"
#      sourceRef:
#        kind: "GitRepository"
#        name: ${var.fluxcd.gitrepository_name}
#        namespace: ${var.helm.namespace.name}
#      upgrade:
#        cleanupOnFail: true
#        remediation:
#          ignoreTestFailures: false
#          remediateLastFailure: true
#          retries: 0
#          strategy: "rollback"
#      releaseName: ${var.fluxcd.helmrelease_name}
#      targetNamespace: ${var.helm.namespace.name}
#      install:
#        createNamespace: true
#        remediation:
#          ignoreTestFailures: false
#          remediateLastFailure: true
#          retries: 0
#  valuesFrom:
#  - kind: "ConfigMap"
#    name: ${var.helm.values.name}
#    valuesKey: ${var.helm.values.configmap_key}
#YAML
#}

#data "aws_eks_cluster_auth" "cluster" {
#  name = var.eks_cluster_id
#}

#data "aws_region" "current" {}

#provider "kubernetes" {
#  host                   = var.eks_host
#  cluster_ca_certificate = base64decode(var.eks_certificate_authority_data)
#  token                  = data.aws_eks_cluster_auth.cluster.token
#  config_path            = ""
#}
#
#provider "helm" {
#  kubernetes {
#    host                   = var.eks_host
#    cluster_ca_certificate = base64decode(var.eks_certificate_authority_data)
#    token                  = data.aws_eks_cluster_auth.cluster.token
#    config_path            = ""
#  }
#}
#
#provider "kubectl" {
#  host                   = var.eks_host
#  cluster_ca_certificate = base64decode(var.eks_certificate_authority_data)
#  token                  = data.aws_eks_cluster_auth.cluster.token
#  load_config_file       = false
#}
# Optionally create application secrets
# secret to pull private images
resource "kubernetes_secret_v1" "secrets" {
  for_each = var.secrets != null ? var.secrets : {}
  metadata {
    name      = each.key
    namespace = each.value.namespace
  }
  type = each.value.type
  data = {
    for item in each.value.values : item.secret_name => item.secret_value
  }
}

#
# Slack alerts
#
resource "kubernetes_manifest" "flux_alert_provider" {
  count = var.alerts != {} ? 1 : 0
  manifest = {
    apiVersion = "notification.toolkit.fluxcd.io/v1beta3"
    kind       = "Provider"
    metadata = {
      name      = "slack-bot"
      namespace = var.helm.namespace.name
    }
    spec = {
      type    = "slack"
      channel = var.alerts.channel
      address = var.alerts.address
    }
  }
}

resource "kubernetes_manifest" "flux_alert" {
  count = var.alerts != {} ? 1 : 0
  manifest = {
    apiVersion = "notification.toolkit.fluxcd.io/v1beta3"
    kind       = "Alert"
    metadata = {
      name      = "slack"
      namespace = var.helm.namespace.name
    }
    spec = {
      summary = var.alerts.summary
      providerRef = {
        name = kubernetes_manifest.flux_alert_provider[0].manifest.metadata.name
      }
      eventSeverity = var.alerts.severity
      eventSources = [
        {
          kind = "GitRepository"
          name = "*"
        },
        {
          kind = "HelmRelease"
          name = "*"
        }
      ]
    }
  }
}
