#!/bin/bash
# Creates an EC2 Launch Template for the Gies Coffee Shop demo
# Run this once with appropriate AWS credentials

TEMPLATE_NAME="GiesCoffeeShop-Template"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERDATA=$(base64 -w 0 "$SCRIPT_DIR/userdata.sh")

aws ec2 create-launch-template \
  --launch-template-name "$TEMPLATE_NAME" \
  --version-description "Week 3 Demo - Coffee Shop" \
  --launch-template-data "{
    \"ImageId\": \"$(aws ssm get-parameter --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)\",
    \"InstanceType\": \"t2.micro\",
    \"UserData\": \"$USERDATA\",
    \"TagSpecifications\": [{
      \"ResourceType\": \"instance\",
      \"Tags\": [{\"Key\": \"Name\", \"Value\": \"GiesCoffeeShop-Demo\"}]
    }]
  }"

echo "Launch template '$TEMPLATE_NAME' created."
echo "Students can launch instances from: EC2 > Launch Templates > $TEMPLATE_NAME > Launch Instance"
