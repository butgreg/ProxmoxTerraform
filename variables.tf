variable "proxmox_ip" {
  description = "IP address of the Proxmox server"
  type        = string
  default    = "192.168.0.175"
}

variable "proxmox_user" {
  description = "Proxmox user with API access"
  type        = string
  default = "terraform@pam!new_token_id"
}

variable "proxmox_password" {
  description = "Proxmox API token secret"
  type        = string
}

variable "proxmox_node" {
  description = "Name of the proxmox node where the LXC containers will be deployed"
  type        = string
  default     = "pve"
  
}

variable "proxmox_api_url" {
  description = "URL of the Proxmox API"
  type        = string
}

variable "ssh_public_key" {
    default = <<EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbYmgNMlEs6RVe29+G3KoYMyOrjd09h5rPZ7/DeAXR4F6w3e1vtZgBko30W8RWtkoHrqDGZPGFvsmQpm/r5wzbe+/PJUPwyD8gtreerWuG+EPec27DOtrtGzDcXDE9NcyvpP4uz+VoLQN40zKeWZyuUsItZuTa0jB3nymgpnvsH4W4QpR5nFkTSQJcpVPRx/Hidv2S3LTOt2OIuvqI73PeoJbuRMK970c6VoV/+4GojeKVjLVbjhdDFPQm242kQCZdb4SaPKSfO8jdv/vy8ICm9QbWZxjK1rrqGw0Cjh8QvMGQ37ilvGk9+T/SrYfycZ5qq3LwFoArLVRdpOMHRaxFLe58JULSM7W2id60OLCNnYeXTENbEQY5BO9sAT5Op/swzxhBk1Zwn61tiRYO9dRG0oTWLxltQh7yhT27YEnkfCX8NdEnEasFSvZKh9QrEVQa+vu09AGW41OmgnmTGCFIoaFBMkDFDouKV0QogW0OzqQxUGp/PaVGey06s77y5p+lyxlh8dqNfKszWAI0PG4wV2pFfHOtEH8+KiGcwXywtJrg2VCxB87E9PLXPvnzb0tHzlqQOKqUtm7TqFTdaXK+WqKPFHqjEHTLmQMHoElwPP/BBtsJwZXIYuNwR5CAqsbhAWmMLq/9jUUdQTcGdWB+J3kArKCEjlLKYiK0mLM97Q== terraform@pam
    EOT
}

variable "container_name" {
  description = "Name of the new LXC container"
  type        = string
  
}
variable "container_id" {
  description = "Unique container ID"
  type        = number
  
}

variable "container_template_id" {
  description = "Id of the template to clone"
  type       = number
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

variable "storage" {
  description = "Proxmox storage location for the container"
  type        = string
  default     = "RaidArray"
}

variable "vm_name" {
  description = "Name of the new virtual machine"
  type        = string
}

variable "vm_memory" {
  description = "Memory allocation for the VM in MB"
  type        = number
  default     = 1024
}
variable "vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 1
}
variable "vm_storage" {
  description = "Disk size for the VM in GB"
  type        = number
  default     = 4
}

variable "vm_storage_pool" {
  description = "Proxmox storage location for the VM"
  type        = string
  default     = "RaidArray"
}   

variable "vm_disk_type" {
  description = "Disk type for the VM"
  type        = string
  default     = "scsi"
}

variable "vm_id" {
  description = "Unique VM ID"
  type        = number
}

variable "vm_template_id" {
  description = "ID of the vm template to clone"
  type        = number
}

variable "vm_network_bridge" {
  description = "Bridge to attach the VM to"
  type        = string
  default     = "vmbr0"  
}





