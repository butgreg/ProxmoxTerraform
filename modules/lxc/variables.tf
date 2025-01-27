variable "container_name" {
  description = "Hostname of the container"
  type        = string
}

variable "container_id" {
  description = "Unique container ID"
  type        = number  
}

variable "container_template_id" {
  description = "ID of the LXC template to use"
  type        = string
}

variable "container_storage" {
  description = "Proxmox storage location for the container"
  type        = string
  default     = "RaidArray"
}

variable "container_memory" {
  description = "Memory allocation for the container in MB"
  type        = number
  default     = 512
}

variable "container_cores" {
  description = "Number of CPU cores for the container"
  type        = number
  default     = 1
}

variable "container_network_bridge" {
  description = "Bridge to attach the container to"
  type        = string
  default     = "vmbr0"
}

variable "container_ip" {
  description = "Static IP address for the container"
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the container"
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox node to deploy the container on"
  type        = string
  }
