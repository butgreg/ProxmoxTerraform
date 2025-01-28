variable "proxmox_node" {
  description = "Name of the Proxmox node"
  type        = string
  default     = "pve"
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = ""
}

variable "vm_id" {
  description = "Unique VM ID"
  type        = number
}

variable "vm_template_id" {
  description = "Template ID to clone"
  type        = number
}

variable "vm_full_clone" {
  description = "Whether to create a full clone of the template"
  type        = bool
  default     = true
}

variable "vm_storage_pool" {
  description = "Storage pool for the VM"
  type        = string
  default     = "RaidArray"
}

variable "vm_storage" {
  description = "Disk size for the VM (in GB)"
  type        = number
  default     = 4
}

variable "vm_disk_size" {
  description = "Disk size for the VM (in GB)"
  type        = number
  default     = 20
}

variable "vm_memory" {
  description = "Memory allocation for the VM (in MB)"
  type        = number
  default     = 2048
}

variable "vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "vm_network_bridge" {
  description = "Network bridge for the VM"
  type        = string
  default     = "vmbr0"
}

variable "ssh_public_key" {
  description = "SSH public key for access"
  type        = string
}
