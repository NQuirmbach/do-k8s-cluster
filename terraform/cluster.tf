resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "app-cluster-${local.enviroment}"
  region  = var.region
  version = var.cluster_version

  node_pool {
    name       = "app-cluster-pool-${local.enviroment}"
    size       = var.cluster_node_size
    node_count = var.cluster_node_count
  }
}
