variable "k8s" {
  description = <<EOF
Kubernetes authentication context.

endpoint       = Cluster API Endpoint.
ca_certificate = Base64 encoded cluster certificate authority.
token          = Bearer token to authenticate with the cluster.
EOF
  type = object({
    endpoint           = string
    ca_certificate     = string
    client_certificate = optional(string, "")
    client_key         = optional(string, "")
    exec_credentials = optional(object({
      command = string
      args    = list(string)
      env     = optional(map(string), {})
    }))
  })
  sensitive = true
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

variable "acme_server" {
  type        = string
  description = "ACME Server"
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
