terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

resource "proxmox_lxc" "container" {
  hostname  = var.container_name
  clone     = var.container_template_id
  full      = true
  target_node = var.proxmox_node
  memory    = var.container_memory
  cores     = var.container_cores
  vmid = var.container_id
  
  rootfs {
    storage = var.container_storage
    size    = "10G"
  }

  network {
    name    = "eth0"
    bridge = var.container_network_bridge
    ip     = "dhcp"
  }

  lifecycle {
    ignore_changes = [network]
  }
}
