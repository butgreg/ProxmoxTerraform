variable "proxmox_node" {
  description = "Name of the Proxmox node"
  type        = string
  default     = "pve"
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = ""
}

variable "container_id" {
  description = "Unique ID for the LXC container"
  type        = number
}

variable "container_template_id" {
  description = "Template ID for the container"
  type        = number
}

variable "container_full_clone" {
  description = "Whether to create a full clone of the template"
  type        = bool
  default     = true
}

variable "container_storage" {
  description = "Storage pool for the container"
  type        = string
  default     = "RaidArray"
}

variable "container_rootfs_size" {
  description = "Root filesystem size (in GB)"
  type        = string
  default     = "10G"
}

variable "container_memory" {
  description = "Memory allocation for the container (in MB)"
  type        = number
  default     = 512
}

variable "container_cores" {
  description = "Number of CPU cores for the container"
  type        = number
  default     = 1
}

variable "container_network_bridge" {
  description = "Network bridge for the container"
  type        = string
  default     = "vmbr0"
}

variable "container_ip" {
  description = "Static IP for the container (leave blank for DHCP)"
  type        = string
  default     = ""
}
