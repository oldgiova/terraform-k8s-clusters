include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//kind"
}

inputs = {
  cluster_name = "mybasiccluster"
  node_image   = "kindest/node:v1.27.3"
  kind_config = {
    api_version = "kind.x-k8s.io/v1alpha4"

    kubeadm_config_patches = [
      "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
    ]
    worker_node_count  = 3
    api_server_address = "127.0.0.1"
    api_server_port    = "6443"

  }
}
