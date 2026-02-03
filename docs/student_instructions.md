# Student Instructions - Gies Coffee Shop

## Accessing the Web Dashboard

Open your browser and go to:
```
http://<INSTRUCTOR_IP>:8501
```

Replace `<INSTRUCTOR_IP>` with the IP address provided by your instructor.

## Connecting to the Database from CloudShell

### Step 1: Open CloudShell

1. Log into AWS Console
2. Click the terminal icon in the top navigation bar (or search for "CloudShell")
3. Wait for the shell to initialize

### Step 2: Install MySQL Client

```bash
sudo dnf install -y mariadb105
```

### Step 3: Connect to the Database

```bash
mysql -h <INSTRUCTOR_IP> -u student -p gies_coffee_shop
```

When prompted for password, enter: `coffee123`

### Step 4: Explore!

You're now connected to a real MySQL database running on EC2.

## Sample Queries to Try

### Basic Queries

```sql
-- See all tables
SHOW TABLES;

-- Count menu items
SELECT COUNT(*) FROM menu_items;

-- View the menu
SELECT product_name, category, price FROM menu_items ORDER BY category;
```

### Analytics Queries

```sql
-- Top 5 products by revenue
SELECT product_name, SUM(total_amount) as revenue
FROM daily_sales
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;

-- Revenue by day
SELECT sale_date, SUM(total_amount) as daily_revenue
FROM daily_sales
GROUP BY sale_date
ORDER BY sale_date;

-- Payment method breakdown
SELECT payment_method, COUNT(*) as transactions, SUM(total_amount) as total
FROM daily_sales
GROUP BY payment_method;

-- Customer type analysis
SELECT customer_type, COUNT(*) as orders, AVG(total_amount) as avg_order
FROM daily_sales
GROUP BY customer_type;
```

### Place an Order (INSERT)

```sql
-- Add your own order
INSERT INTO customer_orders (customer_name, product_name, quantity)
VALUES ('YourName', 'Latte', 2);

-- View recent orders
SELECT * FROM customer_orders ORDER BY order_time DESC LIMIT 10;
```

After inserting, refresh the "Recent Orders" tab on the web dashboard to see your order!

## Key Concepts Demonstrated

1. **EC2 as a Web Server**: Streamlit app running on port 8501
2. **EC2 as a Database Server**: MariaDB (MySQL) running on port 3306
3. **Security Groups**: Firewall rules allowing specific ports
4. **SQL Operations**: SELECT, INSERT, GROUP BY, ORDER BY, JOIN, aggregate functions

## Troubleshooting

### Can't connect to database?
- Make sure you're using the correct IP address
- Check that CloudShell has internet access
- Try: `ping <INSTRUCTOR_IP>`

### Access denied?
- Username: `student`
- Password: `coffee123`
- Make sure you're typing the password correctly

### Web page not loading?
- Try refreshing the page
- Make sure you're using `http://` (not `https://`)
- Check that the port is `:8501`
