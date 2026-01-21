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
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
provider "kubectl" {
  config_path = "~/.kube/config"
}

# Step 1: Create the metallb-system namespace
# and elevate permissions for lb speakers.
#
# See: https://metallb.io/installation/#installation-with-helm

resource "kubectl_manifest" "create_metallb_ns" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: ${var.lb_namespace}
  labels:
    pod-security.kubernetes.io/enforce: privileged
    pod-security.kubernetes.io/audit: privileged
    pod-security.kubernetes.io/warn: privileged
YAML
}

# Step 2: Add the MetalLB Helm repo and install with custom values file

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  namespace  = "${var.lb_namespace}"

  set = [
    {
      name  = ".speaker.nodeSelector.metallbSpeakerNode"
      value = "true"
    }
  ]
  depends_on = [kubectl_manifest.create_metallb_ns]
}

# Step 3: Create a "default" IP address pool
#
# See: https://metallb.io/configuration/#layer-2-configuration

resource "kubectl_manifest" "create_default_ipaddress_pool" {
  yaml_body = <<YAML
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: ${var.lb_namespace}
spec:
  addresses:
  - ${var.lb_homelab_ip_pool}
YAML
  depends_on = [helm_release.metallb]
}

# Step 4: Create a "default" L2 advertisement

resource "kubectl_manifest" "create_default_l2_advertisement" {
  yaml_body = <<YAML
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: ${var.lb_namespace}
spec:
  ipAddressPools:
    - default
YAML
  depends_on = [helm_release.metallb]
}
