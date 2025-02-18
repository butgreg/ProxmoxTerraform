output "vm_name" {
  value = proxmox_vm_qemu.vm.name
}

output "vm_id" {
  value = proxmox_vm_qemu.vm.vmid
}

output "vm_node" {
  value = var.proxmox_node
}

output "vm_cores" {
  value = var.vm_cores
}

output "vm_memory" {
  value = var.vm_memory
}

output "cloud_init_user" {
  value = "RaidArray:snippets/user-data.yaml"
}

output "provisioner_command_details" {
  description = "Details for the provisioner command used for manual disk resizing"
  value = {
    vm_id         = proxmox_vm_qemu.vm.vmid
    vm_storage    = var.vm_storage
    proxmox_node  = var.proxmox_node
    storage_pool  = var.vm_storage_pool
  }
}

output "resize_command" {
  description = "The manual qemu-img resize command used in the provisioner"
  value       = "ssh root@${var.proxmox_node} 'qemu-img resize -f raw /mnt/pve/${var.vm_storage_pool}/images/${proxmox_vm_qemu.vm.vmid}/vm-${proxmox_vm_qemu.vm.vmid}-disk-0.raw ${var.vm_storage}G'"
}
