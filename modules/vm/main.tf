terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name         = var.vm_name != "" ? var.vm_name : "vm-${var.vm_id}"
  vmid         = var.vm_id
  clone_id     = var.vm_template_id
  full_clone   = var.vm_full_clone
  target_node  = var.proxmox_node

  disk {
    storage = var.vm_storage_pool
    size    = var.vm_disk_size
    slot    = "scsi0"
    type    = "disk"
  }

  disk {
    storage = var.vm_storage_pool
    type    = "cloudinit"
    slot    = "ide2"
    size    = 1
  }

  cicustom = "user=RaidArray:snippets/user-data.yaml"

  network {
    id     = 0
    model  = "virtio"
    bridge = var.vm_network_bridge
  }

  sshkeys = var.ssh_public_key

  memory = var.vm_memory
  cores  = var.vm_cores

  lifecycle {
    ignore_changes = [disk, network]
  }
}
