#!/bin/bash

echo "Fetching nodes from EKS cluster..."
nodes=$(kubectl get nodes -o json)

if [ $? -ne 0 ]; then
  echo "Error: Failed to fetch nodes. Is your kubeconfig set?"
  exit 1
fi

echo -e "\nNodeName\t\tStatus\t\tAMI Age (Days)"
echo "-----------------------------------------------------------"

current_date=$(date +%s)

node_count=$(echo "$nodes" | jq '.items | length')

if [ "$node_count" -eq 0 ]; then
  echo "No nodes found."
  exit 0
fi

for row in $(echo "${nodes}" | jq -r '.items[] | @base64'); do
  decode() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  name=$(decode '.metadata.name')
  status=$(decode '.status.conditions[] | select(.type=="Ready") | .status')

  # Get the EC2 instance ID
  instance_id=$(decode '.spec.providerID' | cut -d'/' -f5)

  # Get the AMI ID from the instance
  ami_id=$(aws ec2 describe-instances --instance-ids "$instance_id" --query "Reservations[].Instances[].ImageId" --output text 2>/dev/null)

  if [ -z "$ami_id" ]; then
    echo -e "$name\tUnknown\t\tAMI info not found"
    continue
  fi

  # Get AMI creation date
  ami_date=$(aws ec2 describe-images --image-ids "$ami_id" --query "Images[0].CreationDate" --output text 2>/dev/null)

  if [ -z "$ami_date" ]; then
    echo -e "$name\tUnknown\t\tAMI date not found"
    continue
  fi

  ami_timestamp=$(date -d "$ami_date" +%s)
  ami_age_days=$(( (current_date - ami_timestamp) / 86400 ))

  if [ "$status" == "True" ]; then
    node_status="Ready"
  else
    node_status="NotReady"
  fi

  echo -e "$name\t$node_status\t$ami_age_days"
done
