**Proxmox Terraform Project Report**

---

### **Day 1: Install and Configure Terraform**

**Timeline:**
- Started: Evening, January 20, 2025

**Tasks Completed:**
- Installed Terraform v1.10.4 on the management VM (Ubuntu) within the Proxmox homelab.
- Verified the installation with:
  ```bash
  terraform --version
  ```
  Output: Successful.
- Created the project directory:
  ```bash
  mkdir ~/ProxmoxTerraform
  cd ~/ProxmoxTerraform
  ```
  Structure:
  - **main.tf**: Core Terraform configuration.
  - **variables.tf**: Input variables.
  - **outputs.tf**: Outputs for Terraform.
  - Subdirectories for modules and configs.

**Wins:**
- Terraform was fully operational.
- Project directory set up cleanly.

**Challenges:**
- None noted.

---

### **Day 2: Configure Proxmox Provider and Authentication**

**Timeline:**
- Started: January 21, 2025

**Tasks Completed:**
1. Installed the Proxmox Terraform provider:
   - Added the provider block in `main.tf`:
     ```hcl
     terraform {
       required_providers {
         proxmox = {
           source  = "Telmate/proxmox"
           version = "3.0.1-rc6"
         }
       }
     }
     ```
   - Initialized Terraform:
     ```bash
     terraform init
     ```
   - Output: Provider downloaded successfully.

2. Set up API access for Proxmox:
   - Created an API token in Proxmox with VM.Admin permissions.
   - Stored credentials securely using environment variables:
     ```bash
     export TF_VAR_proxmox_user="root@pam"
     export TF_VAR_proxmox_password="<API_Token_Secret>"
     ```

3. Verified the Proxmox provider configuration:
   ```bash
   terraform plan
   ```
   Output: No errors.

**Wins:**
- Provider was successfully initialized and verified.
- API access configured securely.

**Challenges:**
- None noted.

---

### **Day 3: Base Images Preparation**

**Timeline:**
- Started: January 21, 2025, 18:47 (Ubuntu)
- Completed: January 22, 2025, 09:24 (Windows)

**Ubuntu VM (18:47 - 19:07):**
- Created VM:
  - Command:
    ```bash
    qm importdisk 9000 /mnt/pve/RaidArray/template/iso/focal-server-cloudimg-amd64.raw RaidArray
    qm set 9000 --scsihw virtio-scsi-pci --scsi0 RaidArray:9000/vm-9000-disk-0.raw
    qm set 9000 --ide2 RaidArray:cloudinit
    qm set 9000 --boot order=scsi0
    qm template 9000
    ```
  - Successfully converted to a template.
- Issue: Forgot to preload SSH. Will document this as a lesson learned.

**Windows VM (19:30 - 09:24):**
- Created VM using a 3-year-old ISO:
  - Delays due to updates and a buggy cumulative update from January 17, 2025.
- Struggled with Sysprep:
  - Error: "Audit mode cannot be turned on if reserved storage is in use."
  - Fixed by:
    1. Disabling reserved storage in the registry:
       ```bash
       regedit > HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager
       Set ShippedWithReserves = 0
       ```
    2. Cleaning updates:
       ```bash
       net stop wuauserv
       net stop bits
       del "%WINDIR%\SoftwareDistribution" /f /s /q
       net start wuauserv
       net start bits
       ```
    3. Running Sysprep:
       ```bash
       C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /shutdown
       ```
  - Converted to template at 08:53.
- Cloned a new VM (09:24):
  - Verified RDP and installed VirtIO drivers.

**Wins:**
- Ubuntu and Windows templates created successfully.
- RDP verified on cloned Windows VM.

**Challenges:**
- Struggled with Windows updates for hours.
- Buggy January 17, 2025, update caused significant delays.

---

### **Next Steps:**
- Test SSH access for the Ubuntu template.
- Continue with Terraform configuration for automating VM deployments.

