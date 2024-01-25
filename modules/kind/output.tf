output "cluster_ca_certificate" {
  value     = base64encode(kind_cluster.default.cluster_ca_certificate)
  sensitive = true
}

output "cluster_ca_certificate_plain" {
  value     = kind_cluster.default.cluster_ca_certificate
  sensitive = true
}

output "kubeconfig" {
  value     = kind_cluster.default.kubeconfig
  sensitive = true
}

output "client_key" {
  value     = kind_cluster.default.client_key
  sensitive = true
}

output "client_key_enc" {
  value     = base64encode(kind_cluster.default.client_key)
  sensitive = true
}

output "endpoint" {
  value = kind_cluster.default.endpoint
}

output "client_certificate" {
  value     = kind_cluster.default.client_certificate
  sensitive = true
}

output "client_certificate_enc" {
  value     = base64encode(kind_cluster.default.client_certificate)
  sensitive = true
}

output "cluster_name" {
  value = var.cluster_name
}
