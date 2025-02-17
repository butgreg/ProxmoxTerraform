Below is a user guide for the Terraform Proxmox automation project. This guide will help users deploy and manage resources using the tools and configurations developed in the project.

---

# **User Guide: Proxmox Automation with Terraform**

---

## **Table of Contents**
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Setup and Configuration](#setup-and-configuration)
   - [Terraform Installation](#terraform-installation)
   - [Proxmox API Token Setup](#proxmox-api-token-setup)
4. [Usage Instructions](#usage-instructions)
   - [Running the Deployment Script](#running-the-deployment-script)
   - [Customizing Configurations](#customizing-configurations)
5. [Managing Resources](#managing-resources)
   - [Scaling Resources](#scaling-resources)
   - [Destroying Resources](#destroying-resources)
6. [Troubleshooting](#troubleshooting)
7. [Appendices](#appendices)

---

## **1. Introduction**
This guide provides step-by-step instructions to automate the deployment of VMs and LXC containers on a Proxmox VE cluster using Terraform. It covers setup, customization, and resource management, enabling users to provision resources dynamically and ensure consistency across environments.

---

## **2. Prerequisites**
Before you begin, ensure the following requirements are met:
1. **Proxmox VE Environment**:
   - At least one Proxmox node with access to the management API.
   - Templates for Linux VMs, Windows VMs, and LXC containers uploaded to the Proxmox environment.
2. **Management Machine**:
   - An Ubuntu or Linux-based system with Terraform installed.
   - SSH access to the Proxmox host for provisioning tasks.

---

## **3. Setup and Configuration**

### **3.1 Terraform Installation**
Install Terraform on your management machine:
```bash
sudo apt update
sudo apt install -y wget unzip
wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip
unzip terraform_1.4.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

### **3.2 Proxmox API Token Setup**
1. Log into the Proxmox web interface.
2. Create an API token for your user:
   - Navigate to **Datacenter > Permissions > API Tokens**.
   - Assign the `PVEVMAdmin` role to the token for the relevant nodes.
3. Update your `terraform.tfvars` file with the API token:
   ```hcl
   proxmox_user    = "terraform@pam!new_token_id"
   proxmox_password = "<API_Secret_Token>"
   proxmox_api_url  = "https://192.168.0.175:8006/api2/json"
   ```

---

## **4. Usage Instructions**

### **4.1 Running the Deployment Script**
The `deploy.sh` script dynamically provisions VMs and LXC containers based on user inputs.

#### **Syntax**:
```bash
./deploy.sh -vm <ubuntu|windows> -lxc <debian|alpine|ubuntu> -count <#> -ip <IP> -user <username> -password <password>
```

#### **Example Commands**:
1. Deploy an Ubuntu VM and Debian LXC container:
   ```bash
   ./deploy.sh -vm ubuntu -lxc debian -count 1 -ip dhcp -user testuser -password TestPassword2025
   ```

2. Deploy a Windows VM and Ubuntu LXC container:
   ```bash
   ./deploy.sh -vm windows -lxc ubuntu -count 2 -ip 192.168.1.100 -user admin -password SecurePass123
   ```

---

### **4.2 Customizing Configurations**
Users can override default values by editing the `terraform.tfvars` file or providing runtime arguments. Key parameters include:
- **VM Configuration**:
  - `vm_name`, `vm_memory`, `vm_cores`, `vm_storage`
- **LXC Configuration**:
  - `container_name`, `container_memory`, `container_cores`

---

## **5. Managing Resources**

### **5.1 Scaling Resources**
To scale resources (e.g., increase memory or CPU for a VM):
1. Edit `terraform.tfvars` or provide runtime arguments:
   ```bash
   terraform apply -var="vm_memory=4096" -var="vm_cores=4"
   ```

2. Run `terraform apply` to apply changes.

### **5.2 Destroying Resources**
To destroy all resources:
```bash
terraform destroy
```
To destroy specific resources:
```bash
terraform destroy -target=proxmox_vm_qemu.vm -target=proxmox_lxc.container
```

---

## **6. Troubleshooting**

### **6.1 Common Issues**
1. **API Authentication Errors**:
   - Verify the `proxmox_user` and `proxmox_password` in `terraform.tfvars`.
   - Ensure the API token has `PVEVMAdmin` permissions.
2. **Disk Resizing Failures**:
   - Check storage I/O on the Proxmox host using `iostat`.
   - Manually resize the disk if the Terraform API call times out:
     ```bash
     qemu-img resize -f raw /mnt/pve/RaidArray/images/<vm_id>/vm-<vm_id>-disk-0.raw <size>G
     ```
3. **Orphaned Resources**:
   - Use Proxmox CLI to remove leftover resources:
     ```bash
     pct destroy <id>
     qm destroy <id>
     ```

---

## **7. Appendices**

### **7.1 Sample Terraform Configuration**
Refer to the [Terraform VM Module](#artifact-1).

### **7.2 Process Diagram**
Refer to the [Terraform Workflow Diagram](#artifact-2).

### **7.3 Deployment Script**
The `deploy.sh` script automates deployments. Example snippet:
```bash
#!/bin/bash
terraform apply \
  -var="vm_name=${VM_TYPE}-vm" \
  -var="container_name=${LXC_TYPE}-container" \
  -var="container_ip=${IP}" \
  -var="vm_memory=$((COUNT * 1024))" \
  -auto-approve
```


