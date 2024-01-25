include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//kind"
  extra_arguments "env_vars" {
    commands = get_terraform_commands_that_need_vars()
    env_vars = jsondecode(run_cmd("--terragrunt-quiet", "./bin/get-tf-env-vars.sh"))
  }
}

inputs = {
  cluster_name = "myremotecluster"
  node_image   = "kindest/node:v1.27.3"
  kind_config = {
    api_version = "kind.x-k8s.io/v1alpha4"

    kubeadm_config_patches = [
      "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
    ]
    worker_node_count  = 3
    api_server_address = "${get_env("KIND_REMOTE_HOST", "127.0.0.1")}"
    api_server_port    = "6443"

  }
}
