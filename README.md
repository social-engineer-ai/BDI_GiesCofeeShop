# Gies Coffee Shop - EC2 Demo Platform

A demo platform for BADM 558/358 Week 3 that showcases EC2 as both a **web server** (Streamlit on port 8501) and a **database server** (MySQL on port 3306).

## Quick Start (Instructor)

### Option A: CloudFormation (Recommended)

```bash
aws cloudformation create-stack \
  --stack-name gies-coffee-shop \
  --template-body file://deploy/cloudformation.yaml \
  --region us-east-1
```

Wait 3-5 minutes, then get the public IP:
```bash
aws cloudformation describe-stacks --stack-name gies-coffee-shop \
  --query 'Stacks[0].Outputs[?OutputKey==`PublicIP`].OutputValue' --output text
```

### Option B: Manual EC2 Launch

1. Launch a new EC2 instance (Amazon Linux 2023, t2.micro)
2. Configure Security Group to allow ports: 22, 3306, 8501
3. Paste the contents of `deploy/userdata.sh` into User Data
4. Launch and wait 3-5 minutes

## Architecture

```
+-------------------------------------------------------------+
|  EC2 Instance (Amazon Linux 2023, t2.micro)                 |
|                                                             |
|  +----------------------+  +---------------------------+    |
|  |  MariaDB (MySQL)     |  |  Streamlit Web App        |    |
|  |  Port 3306           |  |  Port 8501                |    |
|  |                      |  |                           |    |
|  |  DB: gies_coffee_shop|<-|  Tabs:                    |    |
|  |  Tables:             |  |  - Dashboard (metrics)    |    |
|  |  - menu_items        |  |  - Menu (browse items)    |    |
|  |  - daily_sales       |  |  - Sales Analytics        |    |
|  |  - customer_orders   |  |  - Place Order (write)    |    |
|  |                      |  |  - Recent Orders          |    |
|  +----------------------+  +---------------------------+    |
|                                                             |
|  systemd services: mariadb + gies-coffee-app                |
+-------------------------------------------------------------+
         |                              |
         | Port 3306                    | Port 8501
         v                              v
    Students via                   Students via
    CloudShell                     Browser
    mysql -h IP...                 http://IP:8501
```

## Student Access

### Web Dashboard
Open browser: `http://<PUBLIC_IP>:8501`

### Database (CloudShell)
```bash
# Install MySQL client
sudo dnf install -y mariadb105

# Connect
mysql -h <PUBLIC_IP> -u student -p gies_coffee_shop
# Password: coffee123
```

## Troubleshooting

### SSH into instance
```bash
ssh ec2-user@<PUBLIC_IP>
```

### Check setup status
```bash
cat /home/ec2-user/setup_complete.txt   # Should say SETUP_COMPLETE
cat /var/log/gies-bootstrap.log          # Bootstrap log
cat /var/log/gies-coffee-setup.log       # Setup log
```

### Check services
```bash
sudo systemctl status mariadb
sudo systemctl status gies-coffee-app
sudo journalctl -u gies-coffee-app -n 50
```

### Test database
```bash
mysql -u admin -p'GiesCoffee2026!' -e "SELECT COUNT(*) FROM gies_coffee_shop.menu_items"
```

### Test web app
```bash
curl -s http://localhost:8501 | head -5
```

## Updating After Deployment

```bash
cd /opt/gies-coffee
sudo git pull origin main
sudo systemctl restart gies-coffee-app
```

## Repository Structure

```
BDI_GiesCofeeShop/
|-- README.md
|-- app/
|   |-- app.py                 # Streamlit application
|   |-- requirements.txt       # Python dependencies
|   +-- .streamlit/
|       +-- config.toml        # Streamlit config
|-- db/
|   |-- schema.sql             # Database schema
|   |-- seed_data.sql          # Sample data
|   +-- create_users.sql       # MySQL users
|-- deploy/
|   |-- userdata.sh            # EC2 user data script
|   |-- setup.sh               # Main setup script
|   |-- gies-coffee-app.service# systemd unit file
|   |-- cloudformation.yaml    # CloudFormation template
|   +-- create_launch_template.sh
|-- scripts/
|   +-- student_queries.sql    # Sample SQL queries
+-- docs/
    |-- instructor_guide.md
    +-- student_instructions.md
```

## Security Notes

These are acceptable for a classroom demo but NOT for production:
- MySQL port 3306 open to 0.0.0.0/0
- No HTTPS (HTTP only on port 8501)
- Public IP (changes if instance stops)
- Hardcoded passwords in code
