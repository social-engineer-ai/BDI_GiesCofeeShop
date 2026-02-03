#!/bin/bash
# Gies Coffee Shop - EC2 Bootstrap
# This script ONLY clones the repo and runs setup.sh
# All logic lives in the repo for easy testing and updates
exec > /var/log/gies-bootstrap.log 2>&1
set -ex

echo "=== Bootstrap started at $(date) ==="

# Install git (almost always pre-installed, but just in case)
sudo dnf install -y git

# Clone the repository
REPO_DIR="/opt/gies-coffee"
sudo rm -rf "$REPO_DIR"
sudo git clone https://github.com/social-engineer-ai/BDI_GiesCofeeShop.git "$REPO_DIR"

# Run the setup script
sudo chmod +x "$REPO_DIR/deploy/setup.sh"
sudo bash "$REPO_DIR/deploy/setup.sh"

echo "=== Bootstrap completed at $(date) ==="
