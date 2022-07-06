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

variable "issuer_email" {
  type        = string
  description = "Letsencrypt issuer email"
}

variable "aws_route53_user_name" {
  type        = string
  description = "AWS Route53 dedicated user"
}

variable "issuer_name" {
  type        = string
  description = "kubernetes resource Issuer name"
}

variable "aws_hosted_zone_id" {
  type        = string
  description = "AWS route53 hosted zone id"
}

variable "issued_secret_name" {
  type        = string
  description = "issued secret name"
  default     = "example-issuer-account-key"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-1"
}
