#!/bin/bash

set -e # Exit on any error

echo "Starting Infrastructure Setup..."

# Step 1: Apply Terraform
echo "📦 Applying Terraform configuration..."
cd ../Terraform
terraform init
terraform plan
terraform apply -auto-approve
cd ..

# Step 2: Get instance details
echo "🔍 Fetching EC2 instance details..."

INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=wanderlust-master" "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].InstanceId" --output text)

if [[ -z "$INSTANCE_ID" ]]; then
  echo "❌ No running instance found with tag Name=wanderlust-master"
  exit 1
fi

INSTANCE_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[].Instances[].PublicIpAddress" --output text)

if [[ -z "$INSTANCE_IP" || "$INSTANCE_IP" == "None" ]]; then
  echo "❌ Instance found but no Public IP (private subnet or public IP disabled?)"
  exit 1
fi


# Step 3: Update Ansible inventory
echo "📝 Updating Ansible inventory..."
cat <<EOF > ansible/inventory
[jenkins_masters]
wanderlust-master ansible_host=${INSTANCE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=${HOME}/.ssh/gitops
EOF

# Step 4: Wait for instance to be ready
echo "Waiting for EC2 Instance to be ready..."
sleep 30 # Wait for EC2 Instance to be ready

# Step 5: Run Ansible Playbook
echo "🎭 Running Ansible playbook..."
cd Ansible/
ansible-playbook -i inventory playbook.yml
cd ..

echo "Infrastructure Setup completed! 🎊"