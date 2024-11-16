terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

locals {
  enviroment = terraform.workspace
}

provider "digitalocean" {
}

data "digitalocean_project" "project" {
  name = "k8s-cluster-${local.enviroment}"
}


resource "digitalocean_container_registry" "registry" {
  name                   = "foobar"
  subscription_tier_slug = var.container_registry_tier
}

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


resource "digitalocean_project_resources" "project_resources" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_kubernetes_cluster.cluster.urn,
    digitalocean_container_registry.registry.urn
  ]
}
