-- Gies Coffee Shop Database Schema
-- Creates the database and all required tables

CREATE DATABASE IF NOT EXISTS gies_coffee_shop;
USE gies_coffee_shop;

-- Menu items table
CREATE TABLE IF NOT EXISTS menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(5,2) NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Daily sales transactions table
CREATE TABLE IF NOT EXISTS daily_sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    sale_date DATE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(5,2) NOT NULL,
    total_amount DECIMAL(8,2) NOT NULL,
    payment_method VARCHAR(20),
    customer_type VARCHAR(20) DEFAULT 'Walk-in'
);

-- Customer orders table (for live order placement)
CREATE TABLE IF NOT EXISTS customer_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    product_name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
