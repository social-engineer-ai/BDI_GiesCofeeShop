#!/bin/bash
# Gies Coffee Shop - Full Setup Script
# Called by userdata.sh after cloning the repo
# Can also be run manually for debugging
set -ex
exec > >(tee -a /var/log/gies-coffee-setup.log) 2>&1

REPO_DIR="/opt/gies-coffee"
VENV_DIR="$REPO_DIR/venv"

echo "=== Step 1: System packages ==="
sudo dnf install -y mariadb105-server python3-pip

echo "=== Step 2: Start and configure MySQL ==="
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Allow remote connections
sudo tee /etc/my.cnf.d/remote-access.cnf > /dev/null <<'EOF'
[mysqld]
bind-address = 0.0.0.0
EOF
sudo systemctl restart mariadb

echo "=== Step 3: Initialize database ==="
sudo mysql < "$REPO_DIR/db/schema.sql"
sudo mysql gies_coffee_shop < "$REPO_DIR/db/seed_data.sql"
sudo mysql < "$REPO_DIR/db/create_users.sql"

# Verify database
TABLES=$(sudo mysql -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='gies_coffee_shop'")
echo "Tables created: $TABLES"
if [ "$TABLES" -lt 3 ]; then
    echo "ERROR: Expected 3 tables, got $TABLES"
    exit 1
fi

MENU_COUNT=$(sudo mysql -N -e "SELECT COUNT(*) FROM gies_coffee_shop.menu_items")
echo "Menu items: $MENU_COUNT"

SALES_COUNT=$(sudo mysql -N -e "SELECT COUNT(*) FROM gies_coffee_shop.daily_sales")
echo "Sales records: $SALES_COUNT"

echo "=== Step 4: Create Python virtual environment ==="
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install -r "$REPO_DIR/app/requirements.txt"

# Verify Streamlit installed
"$VENV_DIR/bin/streamlit" --version
echo "Streamlit installed successfully"

echo "=== Step 5: Install systemd service ==="
sudo cp "$REPO_DIR/deploy/gies-coffee-app.service" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gies-coffee-app
sudo systemctl start gies-coffee-app

echo "=== Step 6: Health check ==="
sleep 5
# Check if Streamlit is responding
for i in {1..6}; do
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8501 | grep -q "200"; then
        echo "Streamlit is running and responding!"
        break
    fi
    echo "Waiting for Streamlit... attempt $i/6"
    sleep 5
done

# Final status
sudo systemctl status gies-coffee-app --no-pager
echo "=== Setup complete at $(date) ==="
echo "SETUP_COMPLETE" > /home/ec2-user/setup_complete.txt
