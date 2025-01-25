# Proxmox Terraform Preparation Phase Report

---

## **Day 1: Install and Configure Terraform**

### **Timeline:**
- **Started:** Evening, January 20, 2025

### **Tasks Completed:**
- Installed Terraform v1.10.4 on the management VM (Ubuntu) within the Proxmox homelab.
- Verified the installation using:
  ```bash
  terraform --version
  ```
  - Output: Successful.
- Created the project directory structure:
  ```bash
  mkdir ~/ProxmoxTerraform
  cd ~/ProxmoxTerraform
  ```
  - Structure:
    - **main.tf**: Core Terraform configuration.
    - **variables.tf**: Input variables.
    - **outputs.tf**: Outputs for Terraform.
    - Subdirectories for modules and configurations.

### **Wins:**
- Terraform was fully operational.
- Project directory was set up cleanly.

### **Challenges:**
- None noted.

---

## **Day 2: Configure Proxmox Provider and Authentication**

### **Timeline:**
- **Started:** January 21, 2025

### **Tasks Completed:**
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
     export TF_VAR_proxmox_user="<token_id>>"
     export TF_VAR_proxmox_password="<API_Token_Secret>"
     ```

3. Verified the Proxmox provider configuration:
   ```bash
   terraform plan
   ```
   - Output: No errors.

### **Wins:**
- Provider was successfully initialized and verified.
- API access was configured securely.

### **Challenges:**
- None noted.

---

## **Day 3: Base Images Preparation**

### **Timeline:**
- **Started:** January 21, 2025, 18:47 (Ubuntu)
- **Completed:** January 22, 2025, 09:24 (Windows)

### **Ubuntu VM (18:47 - 19:07):**
- Created VM:
  ```bash
  qm importdisk 9000 /mnt/pve/RaidArray/template/iso/focal-server-cloudimg-amd64.raw RaidArray
  qm set 9000 --scsihw virtio-scsi-pci --scsi0 RaidArray:9000/vm-9000-disk-0.raw
  qm set 9000 --ide2 RaidArray:cloudinit
  qm set 9000 --boot order=scsi0
  qm template 9000
  ```
- Successfully converted to a template.
- **Issue:** Forgot to preload SSH. Will document this as a lesson learned.

### **Windows VM (19:30 - 09:24):**
- Created VM using a 3-year-old ISO:
  - Delays due to updates and a buggy cumulative update from January 17, 2025.
- Struggled with Sysprep:
  - **Error:** "Audit mode cannot be turned on if reserved storage is in use."
  - **Fix:**
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

### **Wins:**
- Ubuntu and Windows templates were created successfully.
- RDP was verified on cloned Windows VM.

### **Challenges:**
- Struggled with Windows updates for hours.
- Buggy January 17, 2025, update caused significant delays.

---

## **Day 4: Lightweight LXC Templates**

### **Summary:**
Day 4 tasks focused on identifying, downloading, and optimizing lightweight LXC container templates for deployment. Templates for Debian 11, Alpine 3.18, and Ubuntu 20.04 were created, configured, and converted into templates.

### **Timeline:**

#### **Template Downloads:**
- Downloaded base LXC templates to `RaidArray` storage:
  ```bash
  pveam download RaidArray debian-11-standard_11.7-1_amd64.tar.zst
  pveam download RaidArray alpine-3.18-default_20230607_amd64.tar.xz
  pveam download RaidArray ubuntu-20.04-standard_20.04-1_amd64.tar.gz
  ```

#### **Container Creation:**
- **Debian:**
  ```bash
  pct create 9200 RaidArray:vztmpl/debian-11-standard_11.7-1_amd64.tar.zst --rootfs RaidArray:4 --memory 512 --cores 1 --net0 name=eth0,bridge=vmbr0,ip=dhcp
  ```
- **Alpine:**
  ```bash
  pct create 9201 RaidArray:vztmpl/alpine-3.18-default_20230607_amd64.tar.xz --rootfs RaidArray:4 --memory 512 --cores 1 --net0 name=eth0,bridge=vmbr0,ip=dhcp
  ```
- **Ubuntu:**
  ```bash
  pct create 9202 RaidArray:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz --rootfs RaidArray:4 --memory 512 --cores 1 --net0 name=eth0,bridge=vmbr0,ip=dhcp
  ```

#### **Container Updates and Optimization:**

- **Debian (9200):**
  ```bash
  pct exec 9200 -- apt update && apt upgrade -y
  pct exec 9200 -- apt install -y openssh-server net-tools iproute2 nano vim apt-transport-https ca-certificates gnupg htop iotop ufw git zip unzip tar gzip curl wget dnsutils
  pct stop 9200
  pct template 9200
  ```

- **Alpine (9201):**
  ```bash
  pct exec 9201 -- apk update && apk add openssh iproute2 net-tools nano vim htop iptables git zip unzip tar gzip curl wget bind-tools
  pct stop 9201
  pct template 9201
  ```

- **Ubuntu (9202):**
  ```bash
  pct exec 9202 -- apt update && apt upgrade -y
  pct exec 9202 -- apt install -y openssh-server net-tools iproute2 nano vim apt-transport-https ca-certificates gnupg htop iotop ufw git zip unzip tar gzip curl wget dnsutils
  pct stop 9202
  pct template 9202
  ```

### **Wins:**
- Successfully identified and downloaded LXC templates for Debian, Alpine, and Ubuntu.
- Configured and optimized containers with essential tools for various use cases.
- Converted all containers to templates stored on `RaidArray` for future deployments.

### **Challenges:**
- Network settings for container DHCP required additional troubleshooting.
- Timed container updates for automation reporting delayed the timeline slightly.

---

### **Next Steps:**
1. Integrate LXC templates into Terraform automation workflows.
2. Research enhancements for containerized services, including pre-configured monitoring and security tools.
3. Document additional template testing results for deployment consistency.

