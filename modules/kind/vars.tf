variable "cluster_name" {
  type        = string
  description = "cluster name"
}

variable "node_image" {
  type        = string
  description = "Node image version"
}

variable "wait_for_ready" {
  type        = bool
  description = "Defines wether or not the provider will wait for the control plane to be ready."
  default     = false
}

variable "kind_config" {
  description = "Kind custom config"
  type = object({
    api_version            = string
    kubeadm_config_patches = list(string)
    worker_node_count      = number
    api_server_address     = optional(string, "127.0.0.1")
    api_server_port        = optional(string, "6443")
  })
}

variable "api_server_address" {
  type        = string
  description = "Kind apiServerAddress"
  default     = "127.0.0.1"
}

