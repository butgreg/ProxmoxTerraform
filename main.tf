terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}
provider "proxmox" {
  pm_api_url      = "https://${var.proxmox_ip}:8006/api2/json"
  pm_api_token_id         = var.proxmox_user
  pm_api_token_secret     = var.proxmox_password
  pm_timeout          = 300 # Timeout in seconds
  pm_tls_insecure = true
}

module "vm" {
  source            = "./modules/vm"
  providers = {
    proxmox = proxmox
  }
  vm_name           = var.vm_name
  proxmox_node      = var.proxmox_node
  vm_id             = var.vm_id
  vm_template_id    = var.vm_template_id
  vm_storage_pool   = var.vm_storage_pool
  vm_storage        = var.vm_storage
  vm_network_bridge = var.vm_network_bridge
  vm_memory         = var.vm_memory
  vm_cores          = var.vm_cores
  ssh_public_key    = var.ssh_public_key
}

module "lxc_container" {
  source                = "./modules/lxc"
  providers = {
    proxmox = proxmox
  }
  container_id          = var.container_id
  proxmox_node          = var.proxmox_node
  container_name        = "nginx-container"
  container_template_id = var.container_template_id
  container_storage     = "RaidArray"
  container_memory      = 512
  container_cores       = 1
  container_network_bridge = "vmbr0"
  container_ip          = "192.168.1.100"
}
