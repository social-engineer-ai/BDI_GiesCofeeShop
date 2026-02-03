-- ============================================
-- Gies Coffee Shop - Student SQL Exercises
-- BADM 558/358 Week 3
-- ============================================

-- Connect with: mysql -h <IP> -u student -p gies_coffee_shop
-- Password: coffee123

-- ============================================
-- PART 1: Basic Queries (SELECT)
-- ============================================

-- 1. View all tables in the database
SHOW TABLES;

-- 2. See the structure of a table
DESCRIBE menu_items;
DESCRIBE daily_sales;
DESCRIBE customer_orders;

-- 3. View all menu items
SELECT * FROM menu_items;

-- 4. View menu items in a specific category
SELECT product_name, price FROM menu_items WHERE category = 'Coffee';

-- 5. Find items under $4
SELECT product_name, category, price FROM menu_items WHERE price < 4.00;

-- ============================================
-- PART 2: Aggregate Functions
-- ============================================

-- 6. Count total menu items
SELECT COUNT(*) AS total_items FROM menu_items;

-- 7. Count items per category
SELECT category, COUNT(*) AS item_count
FROM menu_items
GROUP BY category;

-- 8. Find average price by category
SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category;

-- 9. Total revenue from all sales
SELECT SUM(total_amount) AS total_revenue FROM daily_sales;

-- 10. Average transaction value
SELECT AVG(total_amount) AS avg_transaction FROM daily_sales;

-- ============================================
-- PART 3: Sorting and Filtering
-- ============================================

-- 11. Top 5 products by revenue
SELECT product_name, SUM(total_amount) AS revenue
FROM daily_sales
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;

-- 12. Daily revenue breakdown
SELECT sale_date, SUM(total_amount) AS daily_revenue
FROM daily_sales
GROUP BY sale_date
ORDER BY sale_date;

-- 13. Most popular items (by quantity sold)
SELECT product_name, SUM(quantity) AS total_units
FROM daily_sales
GROUP BY product_name
ORDER BY total_units DESC
LIMIT 10;

-- ============================================
-- PART 4: Grouping & Business Analysis
-- ============================================

-- 14. Revenue by payment method
SELECT payment_method,
       COUNT(*) AS transactions,
       SUM(total_amount) AS revenue
FROM daily_sales
GROUP BY payment_method
ORDER BY revenue DESC;

-- 15. Customer type analysis
SELECT customer_type,
       COUNT(*) AS transactions,
       SUM(total_amount) AS revenue,
       AVG(total_amount) AS avg_order
FROM daily_sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- 16. Revenue by category
SELECT category,
       SUM(quantity) AS units_sold,
       SUM(total_amount) AS revenue
FROM daily_sales
GROUP BY category
ORDER BY revenue DESC;

-- ============================================
-- PART 5: Writing Data (INSERT)
-- ============================================

-- 17. Place a new order (replace YourName with your name!)
INSERT INTO customer_orders (customer_name, product_name, quantity)
VALUES ('YourName', 'Latte', 2);

-- 18. View your order
SELECT * FROM customer_orders
WHERE customer_name = 'YourName'
ORDER BY order_time DESC;

-- 19. View all recent orders
SELECT * FROM customer_orders
ORDER BY order_time DESC
LIMIT 20;

-- ============================================
-- PART 6: JOINs
-- ============================================

-- 20. Orders with prices (JOIN example)
SELECT
    co.order_id,
    co.customer_name,
    co.product_name,
    co.quantity,
    mi.price AS unit_price,
    (co.quantity * mi.price) AS total
FROM customer_orders co
JOIN menu_items mi ON co.product_name = mi.product_name
ORDER BY co.order_time DESC
LIMIT 10;

-- ============================================
-- CHALLENGE QUERIES
-- ============================================

-- C1. Find the most expensive item in each category
SELECT m1.category, m1.product_name, m1.price
FROM menu_items m1
WHERE m1.price = (
    SELECT MAX(m2.price)
    FROM menu_items m2
    WHERE m2.category = m1.category
);

-- C2. Which day had the highest revenue?
SELECT sale_date, SUM(total_amount) AS revenue
FROM daily_sales
GROUP BY sale_date
ORDER BY revenue DESC
LIMIT 1;

-- C3. What percentage of revenue comes from Coffee?
SELECT
    (SELECT SUM(total_amount) FROM daily_sales WHERE category = 'Coffee') /
    (SELECT SUM(total_amount) FROM daily_sales) * 100 AS coffee_percentage;

-- Happy querying!
