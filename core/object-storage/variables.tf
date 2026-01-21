variable "object_storage_disks" {
 type = string
 default = "/data/disk0,/data/disk1,/data/disk2,/data/disk3"
 description = "The disk paths for the object storage volumes for this deployment."
}

variable "object_storage_namespace" {
 type = string
 default = "object-storage"
 description = "The namespace for the object storage deployment."
}
