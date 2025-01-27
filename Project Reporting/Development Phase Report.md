# **Development Day 1 Report**

## **Summary**

Development Day 1 focused on configuring the Terraform Proxmox provider and establishing token-based authentication. The setup was validated through functional tests to confirm seamless interaction between Terraform and Proxmox.

---

## **Details**

### **Initial Issue**
- The original provider block in `main.tf` used user credentials instead of the API token, resulting in authentication failures (`401 errors`) during `terraform plan`.

### **Resolution**
- Updated the provider configuration to include the appropriate API token-based authentication parameters:
  ```hcl
  provider "proxmox" {
    pm_api_url         = "https://192.168.0.175:8006/api2/json"
    pm_api_token_id    = var.proxmox_user
    pm_api_token_secret = var.proxmox_password
    pm_tls_insecure    = true
  }
  ```
- Verified API connectivity using:
  ```bash
  curl -k -X GET "https://192.168.0.175:8006/api2/json/nodes" \
    -H "Authorization: PVEAPIToken=terraform@pam!new_token_id=<API_Token_Secret>"
  ```
- Initialized Terraform and confirmed successful validation using:
  ```bash
  terraform init
  terraform plan
  ```

---

## **Final Configuration**

The revised `main.tf` configuration includes:
```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url         = "https://192.168.0.175:8006/api2/json"
  pm_api_token_id    = var.proxmox_user
  pm_api_token_secret = var.proxmox_password
  pm_tls_insecure    = true
}

resource "proxmox_vm_qemu" "test" {
  name         = "proxmox-connectivity-test"
  target_node  = "pve"
  vmid         = 9001
  clone        = 9000

  disk {
    storage = "RaidArray"
    size    = 4
    slot    = "scsi0"
    type    = "disk"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  memory = 1024
  cores  = 1
}
```

---

## **Outcome**
- Successfully authenticated Terraform with the Proxmox API using token-based credentials.
- Executed `terraform plan` without errors, confirming functional integration.

---

## **Next Steps**
1. Extend Terraform configurations for deploying multiple Proxmox resources.
2. Automate VM provisioning workflows using validated modules.

# **Development Day 2 Report**

## **Summary**

Development Day 2 focused on creating modular Terraform configurations, defining resource naming conventions, and ensuring compatibility with the Proxmox provider. The tasks included resolving issues with the `clone` parameter, implementing variables for dynamic configuration, and validating the deployment of a test VM. All Terraform commands (`init`, `plan`, `apply`) succeeded without incident after adjustments to the configuration.

---

## **Details**

### **Key Updates**

#### **1. Modularized Terraform Files**
- Created `variables.tf`, `terraform.tfvars`, and `main.tf` for modularity and scalability.
- Variables were defined for Proxmox configurations, VM settings, and resource naming conventions.

#### **2. Resolved `clone` Parameter Issue**
- Updated `main.tf` to replace the `clone` parameter with `clone_id`, as `clone` requires a string input (template name), not an integer (template ID).

#### **3. Successful VM Deployment**
- Validated the deployment of a test VM using a minimal Linux template with dynamic resource parameters:
  - Name: `test-vm-9001`
  - Node: `pve`
  - Template ID: `9000`
  - Memory: `1024 MB`
  - Cores: `2`
  - Disk Size: `10 GB`

#### **4. Debugging Enabled**
- Kept Terraform debugging (`TF_LOG=DEBUG`) active for troubleshooting and documentation purposes.

---

## **Final Configuration**

### **`variables.tf`**
```hcl
variable "proxmox_user" {
  description = "Proxmox user with API access"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox API token secret"
  type        = string
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

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "proxmox_node" {
  description = "Name of the Proxmox node"
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

variable "vm_id" {
  description = "Unique VM ID"
  type        = number
}

variable "template_id" {
  description = "ID of the template to clone"
  type        = number
}
```

### **`terraform.tfvars`**
```hcl
proxmox_user    = "terraform@pam!new_token_id"
proxmox_password = "<API_Token_Secret>"
proxmox_api_url = "https://192.168.0.175:8006/api2/json"
vm_id   = 9001
vm_name = "test-vm"
proxmox_node = "pve"
template_id  = 9000
vm_memory    = 1024
vm_cores     = 2
vm_storage   = 10
```

### **`main.tf`**
```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://192.168.0.175:8006/api2/json"
  pm_api_token_id     = var.proxmox_user
  pm_api_token_secret = var.proxmox_password
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "test" {
  name         = "${var.vm_name}-${var.vm_id}"
  target_node  = var.proxmox_node
  vmid         = var.vm_id
  clone_id     = var.template_id

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
```

---

## **Results**
- All Terraform commands (`init`, `plan`, `apply`) executed successfully after replacing `clone` with `clone_id`.
- A test VM was successfully deployed using the updated configurations.

---

## **Next Steps**
1. Use the deployed VM as a foundation for advanced configurations (e.g., additional disks, provisioning multiple VMs).
2. Continue enabling modularity and scalability in Terraform workflows.
3. Document the testing and deployment process for future automation.

# **Days 3-5 Report**

## **Summary**

Days 3 through 5 focused on developing modular Terraform templates for VMs and LXC containers, testing configurations, addressing issues with disk resizing, and implementing improvements for both VM and container management workflows. Progress was made, but challenges remain with disk resizing operations and Terraform’s handling of certain lifecycle events.

---

## **Timeline**

### **Day 3: Modular VM Configuration**
**Tasks Completed:**
- Created modular Terraform templates for VM deployments.
- Integrated the following features:
  - Dynamic VM parameters for memory, cores, and disk size.
  - Cloud-Init support using `cicustom` with a `user-data.yaml` file.
  - Networking via `ipconfig0 = "dhcp"` for dynamic IP assignment.
- Implemented a `local-exec` provisioner to bypass Proxmox API disk resizing using the `qemu-img resize` command.

**Challenges:**
- Disk resizing via the Proxmox API consistently failed due to timeouts and storage performance issues.
- The `local-exec` provisioner did not provide useful logs and failed to improve resizing reliability.

**Wins:**
- Successfully modularized the VM configuration, making it flexible and reusable.
- Introduced lifecycle management with `ignore_changes = [disk]` to prevent redundant resizing attempts by Terraform.

---

### **Day 4: LXC Container Management**
**Tasks Completed:**
- Developed Terraform modules for LXC container provisioning with the following:
  - Support for template-based cloning with `full = true`.
  - Networking configuration using `dhcp` on `vmbr0`.
  - Resource allocations for memory and CPU.
- Ensured `lifecycle { ignore_changes = [network] }` was in place to prevent unnecessary updates to networking configurations.

**Challenges:**
- Terraform recreated containers unnecessarily due to mismatches between the state file and existing resources.
- Manual deletion of orphaned containers in Proxmox left Terraform in an inconsistent state.

**Wins:**
- Achieved modular container configuration with clear variable-based inputs for `vmid`, `storage`, and network settings.
- Mitigated some recreation issues by ignoring dynamic networking changes.

---

### **Day 5: Refinement and Debugging**
**Tasks Completed:**
- Reviewed and tested VM and LXC modules for reliability and consistency.
- Identified issues with Terraform’s failure to clean up resources after partial execution.
- Addressed storage performance bottlenecks and disk resizing failures:
  - Monitored storage I/O during operations and found `sdb` utilization reaching 98.9%.
  - Noted that manual `qemu-img resize` operations on Proxmox succeeded instantly, while API-based attempts failed.

**Challenges:**
- Disk resizing remains a critical issue despite attempts to bypass the API with `local-exec`.
- Terraform’s state handling created recurring issues with orphaned and partially created resources.

**Wins:**
- Confirmed that the `local-exec` provisioner approach, while not fully successful, is key to addressing Terraform’s API limitations with resizing.
- Highlighted the need for robust error handling and cleanup mechanisms in future iterations.

---

## **Lessons Learned**

1. **Disk Resizing**:
   - Proxmox API struggles with disk resizing under high storage I/O utilization.
   - Manual resizing with `qemu-img` is reliable but needs better Terraform integration.

2. **Lifecycle Management**:
   - Using `lifecycle { ignore_changes = [disk, network] }` prevents Terraform from recreating resources unnecessarily.
   - Proper cleanup and state reconciliation are essential for long-term maintainability.

3. **Dynamic Resource Allocation**:
   - Automating `vmid` and `container_id` allocation via Proxmox’s `/cluster/nextid` API could improve workflows and avoid manual conflicts.

4. **Storage Bottlenecks**:
   - High disk utilization on `sdb` (RaidArray) impacts performance during resize operations.
   - Future storage upgrades or optimizations (e.g., adding SSD caching) may alleviate performance issues.

---

## **Next Steps**

1. Investigate alternative methods for managing disk resizing, including external scripts or advanced Terraform workflows.
2. Automate ID allocation for both VMs and containers to minimize manual conflicts.
3. Enhance error handling and logging mechanisms in Terraform to capture meaningful diagnostics for debugging.
4. Optimize Proxmox storage configurations to reduce bottlenecks during intensive operations.
5. Begin preparing for additional testing and integration tasks in the next phase.

---

## **Appendix: Configuration Highlights**

### **VM Module (`modules/vm/main.tf`)**
- Dynamic variables for memory, cores, and storage.
- Cloud-Init integration with `cicustom` pointing to `user-data.yaml`.
- `local-exec` provisioner for manual disk resizing (currently unreliable).

### **LXC Module (`modules/lxc/main.tf`)**
- Supports full template cloning with resource allocations.
- Networking via `vmbr0` with DHCP configuration.
- Lifecycle management to avoid unnecessary updates to networking.

### **Key Variables (`terraform.tfvars`)**
- VM ID: `9001`
- Container ID: `9203`
- Proxmox Node: `pve`
- Storage: `RaidArray`

---

This report captures the key achievements, challenges, and lessons learned over Days 3–5. Despite challenges, significant progress was made toward modular and reusable Terraform configurations.

