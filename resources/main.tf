terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "3.1.1"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.19.0"
    }
#    talos = {
#      source = "siderolabs/talos"
#      version = "0.10.0"
#    }
  }
}

# provider "talos" {
#
# }

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
provider "kubectl" {
  config_path = "~/.kube/config"
}
