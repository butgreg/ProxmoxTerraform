output "container_name" {
  description = "Hostname of the deployed LXC container"
  value       = proxmox_lxc.container.hostname
}

output "container_id" {
  description = "Proxmox ID of the deployed LXC container"
  value       = proxmox_lxc.container.id
}

output "container_node" {
  description = "Proxmox node where the LXC container is deployed"
  value       = var.proxmox_node
}

output "container_ip" {
  description = "IP address of the LXC container"
  value       = var.container_ip
}

output "container_storage" {
  description = "Proxmox storage pool used for the container's root filesystem"
  value       = var.container_storage
}
