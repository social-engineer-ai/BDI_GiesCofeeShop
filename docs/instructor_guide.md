# Instructor Guide - Gies Coffee Shop Demo

## Pre-Class Setup

### 1. Deploy the Instance

**Option A: CloudFormation (Recommended)**

```bash
# Set your AWS credentials
export AWS_ACCESS_KEY_ID=<your-key>
export AWS_SECRET_ACCESS_KEY=<your-secret>
export AWS_DEFAULT_REGION=us-east-1

# Create the stack
aws cloudformation create-stack \
  --stack-name gies-coffee-shop \
  --template-body file://deploy/cloudformation.yaml

# Wait for completion (3-5 minutes)
aws cloudformation wait stack-create-complete --stack-name gies-coffee-shop

# Get outputs
aws cloudformation describe-stacks --stack-name gies-coffee-shop \
  --query 'Stacks[0].Outputs'
```

**Option B: AWS Console**

1. Go to EC2 > Launch Instance
2. Select Amazon Linux 2023
3. Instance type: t2.micro
4. Network settings: Create security group with:
   - SSH (22) from anywhere
   - Custom TCP (3306) from anywhere
   - Custom TCP (8501) from anywhere
5. Advanced details > User data: paste contents of `deploy/userdata.sh`
6. Launch instance

### 2. Verify Deployment

Wait 3-5 minutes, then:

```bash
# Test web app
curl http://<PUBLIC_IP>:8501

# Test database
mysql -h <PUBLIC_IP> -u student -pcoffee123 -e "SELECT COUNT(*) FROM gies_coffee_shop.menu_items"
```

### 3. Share with Students

Provide students with:
- Public IP address
- Web URL: `http://<PUBLIC_IP>:8501`
- Database credentials: user=`student`, password=`coffee123`

## During Class

### Demo Points

1. **Dashboard Tab**: Show live metrics from database
2. **Place Order Tab**: Have students place orders
3. **Recent Orders Tab**: Watch orders appear in real-time
4. **CloudShell**: Run SQL queries against same database

### Student CloudShell Activity

Have students:
1. Open AWS CloudShell
2. Install MySQL client: `sudo dnf install -y mariadb105`
3. Connect: `mysql -h <IP> -u student -p gies_coffee_shop`
4. Run queries from `scripts/student_queries.sql`

## Post-Class

### Terminate Resources

**CloudFormation:**
```bash
aws cloudformation delete-stack --stack-name gies-coffee-shop
```

**Manual:**
1. EC2 > Instances > Select > Terminate
2. EC2 > Security Groups > Delete the coffee shop SG

## Troubleshooting

### Instance not responding

SSH in and check logs:
```bash
ssh ec2-user@<IP>
cat /var/log/gies-bootstrap.log
cat /var/log/gies-coffee-setup.log
```

### Web app not loading

```bash
sudo systemctl status gies-coffee-app
sudo journalctl -u gies-coffee-app -n 100
```

### Database connection issues

```bash
sudo systemctl status mariadb
mysql -u admin -p'GiesCoffee2026!' -e "SHOW DATABASES"
```

### Quick fix: Re-run setup

```bash
sudo bash /opt/gies-coffee/deploy/setup.sh
```
