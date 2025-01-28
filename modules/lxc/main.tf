terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

resource "proxmox_lxc" "container" {
  hostname   = var.container_name != "" ? var.container_name : "lxc-service-${var.container_id}"
  vmid       = var.container_id
  clone      = var.container_template_id
  full       = var.container_full_clone
  target_node = var.proxmox_node
  

  rootfs {
    storage = var.container_storage
    size    = var.container_rootfs_size
  }

  memory   = var.container_memory
  cores    = var.container_cores

  network {
    name   = "eth0"
    bridge = var.container_network_bridge
    ip     = var.container_ip != "" ? var.container_ip : "dhcp"
  }

  lifecycle {
    ignore_changes = [network]
  }
}
