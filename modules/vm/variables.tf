variable "proxmox_ip" {
  description = "IP address of the Proxmox server"
  type        = string
}
variable "proxmox_node" {
    description = "Name of the proxmox node"
    type        = string
}
variable "vm_name" {
    description = "Name of the new virtual machine"
    type        = string
}
variable "vm_id" {
    description = "Unique VM ID"
    type        = number
}
variable "vm_template_id" {
    description = "ID of the template to clone"
    type        = number
}
variable "vm_storage_pool" {
    description = "Proxmox storage location for the VM"
    default = "RaidArray" 
    }
variable "vm_storage" {
    description = "size of the storage in GB"
    default = 10
    }
variable "vm_disk_type" {
    description = "Disk type for the VM"
    default = "scsi" 
    }
variable "vm_network_bridge" {
    description = "assigned network bridge"
    default = "vmbr0" 
}
variable "vm_memory" {
    description = "value of the memory allocation in MB"
    default = 1024 
}
variable "vm_cores" {
    description = "number of CPU cores"
    default = 2 
}
variable "ssh_public_key" {
  description = "SSH public key for accessing the VM"
  type        = string
  default     = null
}

