#!/bin/bash

# --- CONFIG ---
KEY_NAME="My_AWS_key"                       # AWS key pair name (not .pem)
PEM_PATH="~/.ssh/My_AWS_key.pem"                 # Path to private key
ANSIBLE_USER="ec2-user"                        # EC2 default user for Amazon Linux
VM_IP_FILE="../vm_ip.txt"
INVENTORY_FILE="../ansible/inventory.ini"
LOG_FILE="../logs/provision.log"

# --- START LOGGING ---
mkdir -p ../logs
exec > >(tee -i $LOG_FILE)
exec 2>&1

echo "Starting full infrastructure automation..."
echo "Running Terraform apply..."

# --- TERRAFORM APPLY ---
cd ../terraform || exit 1
terraform apply -auto-approve -var="key_name=$KEY_NAME"

# --- EXTRACT IP ---
cd - > /dev/null || exit 1
if [ ! -f "$VM_IP_FILE" ]; then
  echo "ERROR: vm_ip.txt not found!"
  exit 1
fi

VM_IP=$(cat $VM_IP_FILE | tr -d '\n')
echo "Instance IP: $VM_IP"

# --- WAIT FOR INSTANCE TO BOOT ---
echo "Waiting 60 seconds for EC2 to finish booting..."
sleep 60

# --- UPDATE INVENTORY FILE ---
echo "Updating Ansible inventory with new IP..."
cat <<EOF > $INVENTORY_FILE
[secure]
$VM_IP ansible_user=$ANSIBLE_USER ansible_ssh_private_key_file=$PEM_PATH
EOF

# --- RUN ANSIBLE ---
echo "Running Ansible playbook..."
cd ../ansible || exit 1
ansible-playbook -i inventory.ini site.yml

echo "All tasks completed. Full log saved to $LOG_FILE"
