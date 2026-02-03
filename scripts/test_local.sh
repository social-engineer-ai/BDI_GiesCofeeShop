#!/bin/bash
# Local testing script using Docker for MySQL
# Run this to test the app locally before deploying to EC2

set -e

echo "=== Gies Coffee Shop Local Test ==="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "ERROR: Docker is not running. Please start Docker first."
    exit 1
fi

# Start MySQL container
echo "Starting MySQL container..."
docker rm -f coffee-mysql 2>/dev/null || true
docker run -d --name coffee-mysql -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=root \
    mariadb:10.5

echo "Waiting for MySQL to be ready..."
sleep 10

# Initialize database
echo "Initializing database..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
docker exec -i coffee-mysql mysql -uroot -proot < "$SCRIPT_DIR/db/schema.sql"
docker exec -i coffee-mysql mysql -uroot -proot gies_coffee_shop < "$SCRIPT_DIR/db/seed_data.sql"
docker exec -i coffee-mysql mysql -uroot -proot < "$SCRIPT_DIR/db/create_users.sql"

# Verify
echo "Verifying database..."
MENU_COUNT=$(docker exec coffee-mysql mysql -uroot -proot -N -e "SELECT COUNT(*) FROM gies_coffee_shop.menu_items")
SALES_COUNT=$(docker exec coffee-mysql mysql -uroot -proot -N -e "SELECT COUNT(*) FROM gies_coffee_shop.daily_sales")
echo "Menu items: $MENU_COUNT"
echo "Sales records: $SALES_COUNT"

# Setup Python environment
echo "Setting up Python environment..."
cd "$SCRIPT_DIR/app"
python3 -m venv .venv
source .venv/bin/activate
pip install -q -r requirements.txt

echo ""
echo "=== Setup Complete ==="
echo "To run the app:"
echo "  cd $SCRIPT_DIR/app"
echo "  source .venv/bin/activate"
echo "  streamlit run app.py"
echo ""
echo "To stop MySQL:"
echo "  docker rm -f coffee-mysql"
