terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name         = var.vm_name
  target_node  = var.proxmox_node
  vmid         = var.vm_id
  clone_id     = var.vm_template_id
  full_clone   = true
  ciuser      = "test"
  cipassword =  "test"

  # Main Disk
  disk {
    storage = var.vm_storage_pool
    size    = var.vm_storage
    passthrough = "true"
    slot    = "scsi0"
    type    = "disk"
  }

  # Cloud-Init Disk
  disk {
    storage = var.vm_storage_pool
    type    = "cloudinit"
    slot    = "ide2"
    size    = 1
  }

  # Cloud-Init Customization
  cicustom = "user=RaidArray:snippets/user-data.yaml"

  # Local-Exec Provisioner to Resize Disk
  provisioner "local-exec" {
    command = <<EOT
      ssh -o StrictHostKeyChecking=no root@${var.proxmox_ip} \
        "qemu-img resize -f raw /mnt/pve/${var.vm_storage_pool}/images/${var.vm_id}/vm-${var.vm_id}-disk-0.raw ${var.vm_storage}G"
    EOT
    on_failure = continue
  }

  # Network Configuration
  network {
    id     = 0
    model  = "virtio"
    bridge = var.vm_network_bridge
  }
  ipconfig0 = "dhcp"

  # Optional SSH Keys
  sshkeys = var.ssh_public_key != null ? var.ssh_public_key : null

  # VM Resources
  memory = var.vm_memory
  cores  = var.vm_cores

  # Lifecycle Configuration
  lifecycle {
    ignore_changes = [disk]
  }
}
