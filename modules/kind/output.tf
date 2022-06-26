output "cluster_ca_certificate" {
  value = kind_cluster.default.cluster_ca_certificate
}

output "kubeconfig" {
  value = kind_cluster.default.kubeconfig
}

output "client_key" {
  value = kind_cluster.default.client_key
}

output "endpoint" {
  value = kind_cluster.default.endpoint
}

output "client_certificate" {
  value = kind_cluster.default.client_certificate
}

