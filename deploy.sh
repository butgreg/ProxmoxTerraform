#!/bin/bash

# Default values
VM_TYPE="ubuntu"
LXC_TYPE="debian"
COUNT=1
USER="default-user"
PASSWORD="DefaultPassword"
IP="dhcp"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -vm) VM_TYPE="$2"; shift ;;
    -lxc) LXC_TYPE="$2"; shift ;;
    -count) COUNT="$2"; shift ;;
    -user) USER="$2"; shift ;;
    -password) PASSWORD="$2"; shift ;;
    -ip) IP="$2"; shift ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
  shift
done

# Run Terraform
terraform apply \
  -var="vm_name=${VM_TYPE}-vm" \
  -var="container_name=${LXC_TYPE}-container" \
  -var="container_ip=${IP}" \
  -var="vm_memory=$((COUNT * 1024))" \
  -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)" \
  -var="vm_cores=$COUNT" \
  -auto-approve
