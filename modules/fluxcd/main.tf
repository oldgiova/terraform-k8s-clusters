
# Flux CRD stuff
data "flux_install" "main" {
  target_path = "${var.cluster_type}-flux-manifests}"
}

data "flux_sync" "main" {
  target_path = "${var.cluster_type}-flux-manifests}"
  url         = "ssh://git@github.com/${var.github_owner}/${var.github_repository_name}.git"
  branch      = var.github_gitops_branch
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = var.flux_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

# Flux for Mender.io
resource "kubernetes_manifest" "flux_gitrepository" {
  manifest = {
    apiVersion = "source.toolkit.fluxcd.io/v1beta2"
    kind       = "GitRepository"
    metadata = {
      name      = "hm-helm-manifests-gitrepo"
      namespace = var.flux_namespace
    }
    spec = {
      interval = var.fluxcd_spec_interval
      ref = {
        branch = var.github_gitops_branch
      }
      url = "https://github.com/${var.github_owner}/${var.github_repository_name}"
    }
  }
}

resource "kubernetes_manifest" "flux_helmrelease" {
  manifest = {
    apiVersion = "helm.toolkit.fluxcd.io/v2beta1"
    kind       = "HelmRelease"
    metadata = {
      name      = var.fluxcd_helmrelease_name
      namespace = var.flux_namespace
    }
    spec = {
      interval = var.fluxcd_spec_interval
      chart = {
        spec = {
          chart      = var.fluxcd_gitops_chart_location
          version    = var.fluxcd_chart_version_to_upgrade
          valuesFile = var.fluxcd_chart_valuesfile
          sourceRef = {
            kind = "GitRepository"
            name = kubernetes_manifest.flux_gitrepository.manifest.metadata.name
          }
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
      releaseName     = var.fluxcd_helmrelease_name
      targetNamespace = var.cluster_type == "production" ? "prod" : var.cluster_type
      install = {
        createNamespace = true
        remediation = {
          ignoreTestFailures   = false
          remediateLastFailure = true
          retries              = 0
        }
      }
    }
  }
}
