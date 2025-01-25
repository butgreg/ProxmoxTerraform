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
  name         = "proxmox-connectivity-test"
  target_node  = "pve" # Replace with your Proxmox node name
  vmid         = 9001  # Unique VM ID
  clone        = 9000  # Template VM ID to clone

  disk {
    storage = "RaidArray"
    size    = 4 # Disk size in GB
    slot    = "scsi0"
    type    = "disk"
  }

  network {
    id    = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  memory       = 1024 # Memory in MB
  cores        = 1    # Number of CPU cores
}
