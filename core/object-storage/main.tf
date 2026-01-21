terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "object-storage" {
  name             = "garage"
  repository       = "https://charts.derwitt.dev"
  chart            = "garage/garage"
  namespace        = "${var.object_storage_namespace}"
  create_namespace = "true"

  set = [
    {
      name  = "garage.dbEngine"
      value = "sqlite"
    },
    {
      name  = "persistence.meta.hostPath"
      value = ""
    },
    {
      name  = "persistence.meta.storageClass"
      value = "longhorn"
    }

  ]
}

