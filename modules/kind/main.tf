resource "kind_cluster" "default" {
  name        = var.cluster_name
  node_image  = var.node_image
  kind_config = var.kind_config
}

