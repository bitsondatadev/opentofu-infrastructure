variable "lb_homelab_ip_pool" {
 type = string
 default = "192.168.0.100-192.168.0.150"
 description = "The IP pool the overlays the homelab network for the load balancer to expose apps."

}

variable "lb_namespace" {
 type = string
 default = "load-balancer"
 description = "The namespace for the load balancer deployment."
}
