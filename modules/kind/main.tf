resource "kind_cluster" "default" {
  name       = var.cluster_name
  node_image = var.node_image
  dynamic "kind_config" {
    for_each = var.kind_config != "" ? [var.kind_config] : []
    content {
      kind        = "Cluster"
      api_version = var.kind_config.api_version

      networking {
        api_server_address = var.kind_config.api_server_address
        api_server_port    = var.kind_config.api_server_port

      }

      node {
        role                   = "control-plane"
        kubeadm_config_patches = var.kind_config.kubeadm_config_patches
        extra_port_mappings {
          container_port = 80
          host_port      = 80
        }
        extra_port_mappings {
          container_port = 443
          host_port      = 443
        }
      }


      dynamic "node" {
        #for_each = var.kind_config.worker_node_count > 0 ? tolist(range(1, var.kind_config.worker_node_count)) : []
        for_each = tolist(range(0, var.kind_config.worker_node_count))
        content {
          role = "worker"
        }
      }


    }
  }
  #kind_config = var.kind_config
}

