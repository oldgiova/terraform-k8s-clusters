variable "kubernetes_host" {
  type        = string
  description = "Kubernetes host"
}

variable "kubernetes_client_certificate" {
  type        = string
  description = "Kubernetes client certificate"
}

variable "kubernetes_client_key" {
  type        = string
  description = "Kubernetes client key"
}

variable "kubernetes_cluster_ca_certificate" {
  type        = string
  description = "Kubernetes cluster ca certificate"
}

variable "mender_wildcard_cert" {
  type        = string
  description = "mender.io wildcard certificate"
}

variable "mender_wildcard_privatekey" {
  type        = string
  description = "mender.io wildcard private key"
}

variable "mender_docker_hub_secret" {
  type        = string
  description = "Docker hub secret"
}

variable "cluster_type" {
  type        = string
  description = "Cluster Environment Type"
  default     = "dev"
}

variable "mender_mongodb_connection_string" {
  type        = string
  description = "Mongodb connection string"
}

variable "mender_aws_uri" {
  type        = string
  description = "Mender AWS URI"
  default     = "http://minio"
}

variable "mender_aws_bucket" {
  type        = string
  description = "Mender AWS URI"
  default     = "mender-artifact-storage"
}

variable "mender_aws_auth_key" {
  type        = string
  description = "Mender AWS AUTH KEY"
}

variable "mender_aws_auth_secret" {
  type        = string
  description = "Mender AWS AUTH Secret"
}

variable "mender_aws_force_path_style" {
  type        = bool
  description = "Mender AWS Force path style"
  default     = false
}

variable "mender_presign_hmac_secret" {
  type        = string
  description = "Mender HMAC Presign Secret for AWS"
}

variable "mender_registry_mender_io_secret" {
  type        = string
  description = "registry.mender.io dockerconfigjson secret"
}

variable "mender_stripe_api_key" {
  type        = string
  description = "Mender Stripe API KEY"
  default     = "dummyapikeyu"
}

variable "mender_stripe_api_key_pk" {
  type        = string
  description = "Mender Stripe API KEY PK"
  default     = "dummyapikeyupk"
}

variable "mender_recaptcha_secret" {
  type        = string
  description = "Mender Recaptcha secret"
  default     = "dummyrecaptchasecret"
}

variable "mender_recaptcha_site_key" {
  type        = string
  description = "Mender Recaptcha site key"
  default     = "dummyrecaptchasitekey"
}


