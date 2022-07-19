resource "random_password" "rootpassword" {
  length           = 16
  special          = true
  override_special = "-_"
}

resource "random_password" "replicasetkey" {
  length           = 16
  special          = true
  override_special = "-_"
}

resource "helm_release" "mongodb" {
  depends_on = [
    random_password.replicasetkey,
    random_password.rootpassword
  ]
  name             = "mongodb"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mongodb"
  version          = "11.2.0"
  namespace        = "default"
  create_namespace = true

  set {
    name  = "architecture"
    value = "replicaset"
  }
  set {
    name  = "replicaCount"
    value = "2"
  }
  set {
    name  = "arbiter.enabled"
    value = "true"
  }
  set {
    name  = "auth.rootPassword"
    value = random_password.rootpassword.result
  }
  set {
    name  = "auth.replicaSetKey"
    value = random_password.replicasetkey.result
  }
  set {
    name  = "image.tag"
    value = var.mongodb_image_tag
  }
  set {
    name  = "persistence.size"
    value = var.mongodb_persistence_size
  }
}

