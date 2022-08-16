resource "kubernetes_secret_v1" "mender_wildcard_keycert" {
  metadata {
    name      = "mender-wildcard-keycert"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    "cert.crt"    = var.mender_wildcard_cert
    "private.key" = var.mender_wildcard_privatekey
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "mender_docker_hub_secret" {
  metadata {
    name      = "docker-hub-secret"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    ".dockerconfigjson" = var.mender_docker_hub_secret
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret_v1" "mongodb_common" {
  metadata {
    name      = "mongodb-common"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    "MONGO"     = var.mender_mongodb_connection_string
    "MONGO_URL" = var.mender_mongodb_connection_string
    "MONGO_SSL" = "false"
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "mender_s3_artifacts" {
  metadata {
    name      = "mender-s3-artifacts"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    "AWS_URI"              = var.mender_aws_uri
    "AWS_BUCKET"           = var.mender_aws_bucket
    "AWS_AUTH_KEY"         = var.mender_aws_auth_key
    "AWS_AUTH_SECRET"      = var.mender_aws_auth_secret
    "AWS_FORCE_PATH_STYLE" = var.mender_aws_force_path_style
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "mender_hmac_presigned" {
  metadata {
    name      = "mender-presign-secret"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    "PRESIGN_SECRET" = var.mender_presign_hmac_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "mender_registry_mender_io_secret" {
  metadata {
    name      = "registry-mender-io-secret"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    ".dockerconfigjson" = var.mender_registry_mender_io_secret
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret_v1" "stripe_customers_secret" {
  metadata {
    name      = "stripe-customers-rw"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    "STRIPE_API_KEY"    = var.mender_stripe_api_key
    "STRIPE_API_KEY_PK" = var.mender_stripe_api_key_pk
  }
}

resource "kubernetes_secret_v1" "mender_recaptcha" {
  metadata {
    name      = "mender-recaptcha"
    namespace = var.cluster_type == "production" ? "prod" : var.cluster_type
  }

  data = {
    "RECAPTCHA_SECRET"   = var.mender_recaptcha_secret
    "RECAPTCHA_SITE_KEY" = var.mender_recaptcha_site_key
  }
}


