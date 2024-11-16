terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "csb100320013fe5f0a1"
    container_name       = "tfstate"
    key                  = "app.opentofu.tfstate"
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
  name                   = "appcontainerregistry${local.enviroment}"
  subscription_tier_slug = var.container_registry_tier
  region                 = var.region
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name                 = "app-cluster-${local.enviroment}"
  region               = var.region
  version              = var.cluster_version
  registry_integration = true

  node_pool {
    name       = "app-cluster-pool-${local.enviroment}"
    size       = var.cluster_node_size
    node_count = var.cluster_node_count
  }

  depends_on = [digitalocean_container_registry.registry]
}


resource "digitalocean_project_resources" "project_resources" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_kubernetes_cluster.cluster.urn,
    digitalocean_container_registry.registry.endpoint
  ]
}
