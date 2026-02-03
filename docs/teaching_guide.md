# Teaching Guide: EC2 as Web Server & Database Server
## BADM 558/358 Week 3 — Gies Coffee Shop Demo

---

## Learning Objectives

By the end of this lesson, students will be able to:

1. **Explain** what EC2 is and its role in cloud computing
2. **Identify** the difference between a web server and a database server
3. **Connect** to a MySQL database from AWS CloudShell
4. **Write** basic SQL queries (SELECT, INSERT, GROUP BY, JOIN)
5. **Understand** how web applications interact with databases

---

## Pre-Class Setup (Instructor)

### Option 1: CloudFormation (Recommended — 2 minutes)

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID=<your-key>
export AWS_SECRET_ACCESS_KEY=<your-secret>
export AWS_DEFAULT_REGION=us-east-1

# Launch the stack
aws cloudformation create-stack \
  --stack-name gies-coffee-shop \
  --template-body file://deploy/cloudformation.yaml

# Wait for completion (3-5 minutes)
aws cloudformation wait stack-create-complete --stack-name gies-coffee-shop

# Get the public IP
aws cloudformation describe-stacks \
  --stack-name gies-coffee-shop \
  --query 'Stacks[0].Outputs[?OutputKey==`PublicIP`].OutputValue' \
  --output text
```

### Option 2: AWS Console (Manual)

1. Go to **EC2 → Launch Instance**
2. Name: `GiesCoffeeShop-Demo`
3. AMI: Amazon Linux 2023
4. Instance type: t2.micro
5. Security Group: Allow ports 22, 3306, 8501 from 0.0.0.0/0
6. Advanced → User Data: Paste contents of `deploy/userdata.sh`
7. Launch and wait 3-5 minutes

### Verify Deployment

```bash
# Test web app
curl http://<IP>:8501

# Test database
mysql -h <IP> -u student -pcoffee123 -e "SELECT COUNT(*) FROM gies_coffee_shop.menu_items"
```

---

## Lesson Plan (75 minutes)

### Part 1: Introduction to EC2 (15 min)

**Key Points:**
- EC2 = Elastic Compute Cloud = Virtual servers in AWS
- "Elastic" = can scale up/down based on demand
- Pay only for what you use (by the hour/second)

**Discussion Questions:**
- "What's the difference between running a server in your office vs. in the cloud?"
- "Why might a startup prefer EC2 over buying physical servers?"

**Show the Architecture:**
```
┌─────────────────────────────────────────────────────────┐
│  EC2 Instance (Amazon Linux 2023)                       │
│                                                         │
│  ┌──────────────────────┐  ┌─────────────────────────┐  │
│  │  MariaDB (MySQL)     │  │  Streamlit Web App      │  │
│  │  Port 3306           │  │  Port 8501              │  │
│  │                      │  │                         │  │
│  │  Stores data         │◄─┤  Shows data visually    │  │
│  │  (menu, sales,       │  │  Lets users place       │  │
│  │   orders)            │  │  orders                 │  │
│  └──────────────────────┘  └─────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
         ▲                              ▲
         │                              │
    Students via                   Students via
    CloudShell (SQL)              Browser (Web)
```

**Key Insight:** One EC2 instance is running TWO services:
- A **web server** (Streamlit on port 8501)
- A **database server** (MySQL on port 3306)

---

### Part 2: Live Demo — The Web Dashboard (10 min)

**Open the dashboard:** `http://<IP>:8501`

**Walk through each tab:**

| Tab | What It Shows | SQL Concept |
|-----|---------------|-------------|
| Dashboard | Summary metrics | `SUM()`, `COUNT()`, `AVG()` |
| Menu | Product catalog | `SELECT`, `ORDER BY` |
| Sales Analytics | Charts & reports | `GROUP BY`, aggregates |
| Place Order | Order form | `INSERT` |
| Recent Orders | Order history | `JOIN`, `ORDER BY DESC` |

**Interactive moment:** Ask a student to place an order using the web form. Then show how it appears in "Recent Orders."

---

### Part 3: Hands-On — Connecting via CloudShell (20 min)

**Have students follow along:**

#### Step 1: Open CloudShell
- Click the terminal icon (>_) in the AWS Console top navigation
- Wait for shell to initialize

#### Step 2: Install MySQL Client
```bash
sudo dnf install -y mariadb105
```

#### Step 3: Connect to Database
```bash
mysql -h <INSTRUCTOR_IP> -u student -p gies_coffee_shop
```
Password: `coffee123`

#### Step 4: Explore
```sql
-- See all tables
SHOW TABLES;

-- Look at table structure
DESCRIBE menu_items;

-- Count records
SELECT COUNT(*) FROM menu_items;
SELECT COUNT(*) FROM daily_sales;
```

**Teaching moment:** "You're now connected to the SAME database that powers the web dashboard. Any changes you make here will appear on the website!"

---

### Part 4: SQL Exercises (25 min)

#### Exercise 1: Basic SELECT (5 min)
```sql
-- View the menu
SELECT product_name, category, price
FROM menu_items
ORDER BY price DESC;

-- Find expensive items (over $5)
SELECT product_name, price
FROM menu_items
WHERE price > 5.00;
```

**Question:** "Which is the most expensive item? Which category has the most items?"

#### Exercise 2: Aggregate Functions (5 min)
```sql
-- Total revenue
SELECT SUM(total_amount) as total_revenue FROM daily_sales;

-- Average transaction
SELECT AVG(total_amount) as avg_order FROM daily_sales;

-- Count by category
SELECT category, COUNT(*) as item_count
FROM menu_items
GROUP BY category;
```

**Question:** "What's our average order value? How does that compare to Starbucks?"

#### Exercise 3: GROUP BY Analysis (5 min)
```sql
-- Revenue by product
SELECT product_name, SUM(total_amount) as revenue
FROM daily_sales
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;

-- Revenue by payment method
SELECT payment_method, COUNT(*) as orders, SUM(total_amount) as revenue
FROM daily_sales
GROUP BY payment_method;
```

**Question:** "What's our best-selling product? Which payment method do customers prefer?"

#### Exercise 4: INSERT — Place an Order (5 min)
```sql
-- Place your own order!
INSERT INTO customer_orders (customer_name, product_name, quantity)
VALUES ('YourName', 'Latte', 2);

-- Verify it worked
SELECT * FROM customer_orders
WHERE customer_name = 'YourName';
```

**Action:** After students insert, have them refresh the "Recent Orders" tab on the web dashboard to see their order appear!

#### Exercise 5: Challenge Queries (5 min)
```sql
-- Which day had the highest revenue?
SELECT sale_date, SUM(total_amount) as revenue
FROM daily_sales
GROUP BY sale_date
ORDER BY revenue DESC
LIMIT 1;

-- What percentage of orders are from students?
SELECT
    customer_type,
    COUNT(*) as orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM daily_sales), 1) as percentage
FROM daily_sales
GROUP BY customer_type;
```

---

### Part 5: Wrap-Up & Discussion (5 min)

**Key Takeaways:**

1. **EC2 is versatile** — One instance can run multiple services
2. **Ports matter** — Different services use different ports (3306, 8501)
3. **Security Groups** — Control who can access which ports
4. **SQL is powerful** — Same database serves both web app and direct queries

**Discussion Questions:**
- "Why would we want BOTH a web interface AND direct SQL access?"
- "What security risks did you notice in this demo? (Hint: passwords, open ports)"
- "How would you make this production-ready?"

**Security Teaching Points:**
- Passwords are hardcoded (bad in production)
- Database port is open to the world (bad in production)
- No HTTPS (bad in production)
- This is a demo — production systems need proper security!

---

## Post-Class Cleanup

**Important:** Terminate the instance to avoid charges!

```bash
# If using CloudFormation:
aws cloudformation delete-stack --stack-name gies-coffee-shop

# If using Console:
# EC2 → Instances → Select → Instance State → Terminate
```

---

## Troubleshooting

### "Connection refused" on port 8501
- Setup might still be running (wait 5 minutes)
- Check: `sudo systemctl status gies-coffee-app`

### "Access denied" on MySQL
- Username: `student` (not `admin`)
- Password: `coffee123`
- Make sure you're using the correct IP

### Students can't connect from CloudShell
- Verify Security Group allows port 3306 from 0.0.0.0/0
- Try: `telnet <IP> 3306`

### Web app shows errors
- Check logs: `sudo journalctl -u gies-coffee-app -n 50`
- Restart: `sudo systemctl restart gies-coffee-app`

---

## Assessment Ideas

### Quick Quiz (5 questions)
1. What port does the web application run on?
2. What SQL command adds new data to a table?
3. What does GROUP BY do?
4. Name two things controlled by Security Groups.
5. Why is it bad to hardcode passwords in production?

### Homework Assignment
"Write SQL queries to answer these business questions about the coffee shop data..."

### Project Extension
"Deploy your own EC2 instance and customize the coffee shop (add new menu items, change prices, etc.)"

---

## Files Reference

| File | Purpose |
|------|---------|
| `deploy/cloudformation.yaml` | One-click deployment template |
| `deploy/userdata.sh` | EC2 bootstrap script |
| `scripts/student_queries.sql` | All SQL exercises |
| `docs/student_instructions.md` | Handout for students |

---

## Appendix: Student Credentials

| Resource | Value |
|----------|-------|
| Web Dashboard | `http://<IP>:8501` |
| MySQL Host | `<IP>` |
| MySQL User | `student` |
| MySQL Password | `coffee123` |
| Database Name | `gies_coffee_shop` |

**Admin credentials (instructor only):**
- User: `admin`
- Password: `GiesCoffee2026!`
