-- Gies Coffee Shop MySQL User Creation
-- Creates admin and student users with appropriate permissions

-- Admin user (instructor - full access)
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'GiesCoffee2026!';
GRANT ALL PRIVILEGES ON gies_coffee_shop.* TO 'admin'@'%';

-- Student user (read + insert on orders only)
CREATE USER IF NOT EXISTS 'student'@'%' IDENTIFIED BY 'coffee123';
GRANT SELECT ON gies_coffee_shop.* TO 'student'@'%';
GRANT INSERT ON gies_coffee_shop.customer_orders TO 'student'@'%';

FLUSH PRIVILEGES;
