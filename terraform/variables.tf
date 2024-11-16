variable "region" {
  type        = string
  description = "Digital Ocean region"
  default     = "fra1"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version. CLI command: doctl kubernetes options versions"
}

variable "cluster_node_size" {
  type        = string
  description = "Kubernetes cluster node size. CLI command: doctl compute size list"
}

variable "cluster_node_count" {
  type        = number
  description = "Kubernetes cluster node count"
}

variable "container_registry_tier" {
  type        = string
  description = "Container registry tier: CLI command: doctl registry options subscription-tiers"
}
