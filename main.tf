terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}
provider "proxmox" {
  pm_api_url      = "https://192.168.0.175:8006/api2/json"
  pm_api_token_id         = var.proxmox_user
  pm_api_token_secret     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "test" {
  name         = "${var.vm_name}-${var.vm_id}"
  target_node  = "pve"
  vmid         = var.vm_id
  clone        = 9000 # Template VM ID

  disk {
    storage = "RaidArray"
    size    = var.vm_storage
    slot    = "scsi0"
    type    = "disk"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  memory = var.vm_memory
  cores  = var.vm_cores
}
