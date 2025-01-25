**Proxmox API Key Setup and Configuration**

---
## **Deliverables**

### **Deliverable: Ubuntu Template Configuration**
1. **VM ID**: `9000`
2. **Configuration Commands**:
   ```bash
   virt-customize -a /mnt/pve/RaidArray/template/iso/focal-server-cloudimg-amd64.img --install openssh-server
   qm create 9000 --name "UbuntuTerraformTest" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
   qm importdisk 9000 focal-server-cloudimg-amd64.img RaidArray
   qm set 9000 --scsihw virtio-scsi-pci --scsi0 RaidArray:9000/vm-9000-disk-0.raw
   qm set 9000 --boot c --bootdisk scsi0
   qm set 9000 --ide2 RaidArray:cloudinit
   qm set 9000 --agent 1
   qm template 9000
   ```


### **Deliverable: Proxmox API Key Setup**

**Steps to Create an API Key in Proxmox:**
1. Log in to the Proxmox Web Interface.
2. Navigate to: **Datacenter > Permissions > API Tokens**.
3. Create a token for the `root@pam` user (or a custom user if applicable):
   - **Token Name**: `terraform_user` (example).
   - **Permissions**: Assign **VM.Admin** role.
4. Save the API token and secret securely:
   - API Token: `<username>@<realm>!<token_id>`
   - Secret: `<token_secret>`

**Example API Token Details:**
- **User**: `root@pam`
- **Token Name**: `terraform_user`
- **Full Token ID**: `root@pam!terraform_user`

---

### **Deliverable: API Access Configuration Script**

**Script to Export API Token Credentials Securely:**
Create a script to store and load credentials as environment variables for Terraform:

```bash
#!/bin/bash
# Export Proxmox API Credentials
export TF_VAR_proxmox_user="terraform@pam"
export TF_VAR_proxmox_password="<API_Token_Secret>"
export TF_VAR_proxmox_api_url="https://<Proxmox_Host_IP>:8006/api2/json"

# Confirm the credentials are set
if [[ -z "$TF_VAR_proxmox_user" || -z "$TF_VAR_proxmox_password" || -z "$TF_VAR_proxmox_api_url" ]]; then
  echo "Error: API credentials are not set properly."
  exit 1
else
  echo "Proxmox API credentials exported successfully."
fi
```

**Usage:**
1. Replace `<API_Token_Secret>` and `<Proxmox_Host_IP>` with your Proxmox token secret and IP address.
2. Save this script as `proxmox_api_setup.sh`.
3. Make it executable:
   ```bash
   chmod +x proxmox_api_setup.sh
   ```
4. Run the script:
   ```bash
   ./proxmox_api_setup.sh
   ```

---

### **Deliverable: Verification of API Configuration**

**Terraform Configuration to Verify API Access:**
Use the following Terraform configuration to test connectivity with the Proxmox API:

```hcl
provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "test_vm" {
  count    = 0 # This ensures no VM is created; the purpose is to verify connectivity.
  name     = "api-verification"
  target_node = "<Proxmox_Node_Name>"
  clone {
    vm_id = 9000 # Replace with a valid template ID.
  }
}
```

**Steps to Test:**
1. Initialize the Terraform configuration:
   ```bash
   terraform init
   ```
2. Run a `terraform plan` to validate API connectivity:
   ```bash
   terraform plan
   ```
   - Expected Output: No errors related to API access.

---

### **Expected Outcomes**
1. API Token and credentials securely configured.
2. Terraform able to connect to Proxmox without authentication errors.
3. Verified connectivity with the Proxmox API.

