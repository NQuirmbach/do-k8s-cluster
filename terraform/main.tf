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
  suffix     = random_integer.rid.result
  tags = {
    env = terraform.workspace
    app = "k3s-cluster"
  }
}

provider "digitalocean" {
}

data "digitalocean_project" "project" {
  name = "k8s-cluster-${local.enviroment}"
}

resource "digitalocean_project_resources" "project_resources" {
  project = data.digitalocean_project.project
  resources = [
    digitalocean_kubernetes_cluster.cluster.urn
  ]
}
