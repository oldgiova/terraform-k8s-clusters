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
  default     = true
}
