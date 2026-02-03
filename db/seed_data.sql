-- Gies Coffee Shop Seed Data
-- 20 menu items and 60 sample transactions

USE gies_coffee_shop;

-- Menu Items (20 items across 5 categories)
INSERT INTO menu_items (product_name, category, price, available) VALUES
-- Coffee (6 items)
('Espresso', 'Coffee', 3.00, TRUE),
('Americano', 'Coffee', 3.50, TRUE),
('Latte', 'Coffee', 4.50, TRUE),
('Cappuccino', 'Coffee', 4.50, TRUE),
('Mocha', 'Coffee', 5.00, TRUE),
('Cold Brew', 'Coffee', 4.00, TRUE),
-- Tea (3 items)
('Green Tea', 'Tea', 2.50, TRUE),
('Chai Latte', 'Tea', 4.00, TRUE),
('Earl Grey', 'Tea', 2.50, TRUE),
-- Pastry (5 items)
('Croissant', 'Pastry', 3.50, TRUE),
('Blueberry Muffin', 'Pastry', 3.00, TRUE),
('Chocolate Chip Cookie', 'Pastry', 2.50, TRUE),
('Cinnamon Roll', 'Pastry', 4.00, TRUE),
('Banana Bread', 'Pastry', 3.50, TRUE),
-- Food (4 items)
('Avocado Toast', 'Food', 8.00, TRUE),
('Turkey Sandwich', 'Food', 9.00, TRUE),
('Caesar Salad', 'Food', 7.50, TRUE),
('Bagel with Cream Cheese', 'Food', 4.50, TRUE),
-- Other (2 items)
('Bottled Water', 'Other', 2.00, TRUE),
('Orange Juice', 'Other', 3.50, TRUE);

-- Daily Sales Transactions (60 transactions across Jan 13-15, 2026)
INSERT INTO daily_sales (transaction_id, sale_date, product_name, category, quantity, unit_price, total_amount, payment_method, customer_type) VALUES
-- January 13, 2026 (20 transactions)
('TXN-20260113-001', '2026-01-13', 'Latte', 'Coffee', 2, 4.50, 9.00, 'Credit Card', 'Regular'),
('TXN-20260113-002', '2026-01-13', 'Croissant', 'Pastry', 1, 3.50, 3.50, 'Credit Card', 'Regular'),
('TXN-20260113-003', '2026-01-13', 'Americano', 'Coffee', 1, 3.50, 3.50, 'Cash', 'Walk-in'),
('TXN-20260113-004', '2026-01-13', 'Blueberry Muffin', 'Pastry', 2, 3.00, 6.00, 'Mobile Pay', 'Student'),
('TXN-20260113-005', '2026-01-13', 'Cappuccino', 'Coffee', 1, 4.50, 4.50, 'Credit Card', 'Regular'),
('TXN-20260113-006', '2026-01-13', 'Avocado Toast', 'Food', 1, 8.00, 8.00, 'Credit Card', 'Walk-in'),
('TXN-20260113-007', '2026-01-13', 'Green Tea', 'Tea', 1, 2.50, 2.50, 'Cash', 'Student'),
('TXN-20260113-008', '2026-01-13', 'Mocha', 'Coffee', 2, 5.00, 10.00, 'Mobile Pay', 'Regular'),
('TXN-20260113-009', '2026-01-13', 'Turkey Sandwich', 'Food', 1, 9.00, 9.00, 'Credit Card', 'Walk-in'),
('TXN-20260113-010', '2026-01-13', 'Cold Brew', 'Coffee', 3, 4.00, 12.00, 'Credit Card', 'Student'),
('TXN-20260113-011', '2026-01-13', 'Cinnamon Roll', 'Pastry', 1, 4.00, 4.00, 'Cash', 'Regular'),
('TXN-20260113-012', '2026-01-13', 'Espresso', 'Coffee', 2, 3.00, 6.00, 'Mobile Pay', 'Walk-in'),
('TXN-20260113-013', '2026-01-13', 'Chai Latte', 'Tea', 1, 4.00, 4.00, 'Credit Card', 'Student'),
('TXN-20260113-014', '2026-01-13', 'Chocolate Chip Cookie', 'Pastry', 3, 2.50, 7.50, 'Cash', 'Regular'),
('TXN-20260113-015', '2026-01-13', 'Caesar Salad', 'Food', 1, 7.50, 7.50, 'Credit Card', 'Walk-in'),
('TXN-20260113-016', '2026-01-13', 'Latte', 'Coffee', 1, 4.50, 4.50, 'Mobile Pay', 'Student'),
('TXN-20260113-017', '2026-01-13', 'Bottled Water', 'Other', 2, 2.00, 4.00, 'Cash', 'Walk-in'),
('TXN-20260113-018', '2026-01-13', 'Banana Bread', 'Pastry', 1, 3.50, 3.50, 'Credit Card', 'Regular'),
('TXN-20260113-019', '2026-01-13', 'Americano', 'Coffee', 2, 3.50, 7.00, 'Credit Card', 'Student'),
('TXN-20260113-020', '2026-01-13', 'Bagel with Cream Cheese', 'Food', 1, 4.50, 4.50, 'Mobile Pay', 'Walk-in'),

-- January 14, 2026 (20 transactions)
('TXN-20260114-001', '2026-01-14', 'Cappuccino', 'Coffee', 2, 4.50, 9.00, 'Credit Card', 'Regular'),
('TXN-20260114-002', '2026-01-14', 'Croissant', 'Pastry', 2, 3.50, 7.00, 'Cash', 'Walk-in'),
('TXN-20260114-003', '2026-01-14', 'Mocha', 'Coffee', 1, 5.00, 5.00, 'Mobile Pay', 'Student'),
('TXN-20260114-004', '2026-01-14', 'Earl Grey', 'Tea', 1, 2.50, 2.50, 'Credit Card', 'Regular'),
('TXN-20260114-005', '2026-01-14', 'Avocado Toast', 'Food', 2, 8.00, 16.00, 'Credit Card', 'Walk-in'),
('TXN-20260114-006', '2026-01-14', 'Latte', 'Coffee', 3, 4.50, 13.50, 'Mobile Pay', 'Student'),
('TXN-20260114-007', '2026-01-14', 'Blueberry Muffin', 'Pastry', 1, 3.00, 3.00, 'Cash', 'Regular'),
('TXN-20260114-008', '2026-01-14', 'Cold Brew', 'Coffee', 2, 4.00, 8.00, 'Credit Card', 'Walk-in'),
('TXN-20260114-009', '2026-01-14', 'Turkey Sandwich', 'Food', 1, 9.00, 9.00, 'Credit Card', 'Student'),
('TXN-20260114-010', '2026-01-14', 'Green Tea', 'Tea', 2, 2.50, 5.00, 'Mobile Pay', 'Regular'),
('TXN-20260114-011', '2026-01-14', 'Espresso', 'Coffee', 1, 3.00, 3.00, 'Cash', 'Walk-in'),
('TXN-20260114-012', '2026-01-14', 'Cinnamon Roll', 'Pastry', 2, 4.00, 8.00, 'Credit Card', 'Student'),
('TXN-20260114-013', '2026-01-14', 'Orange Juice', 'Other', 1, 3.50, 3.50, 'Mobile Pay', 'Regular'),
('TXN-20260114-014', '2026-01-14', 'Americano', 'Coffee', 2, 3.50, 7.00, 'Credit Card', 'Walk-in'),
('TXN-20260114-015', '2026-01-14', 'Chocolate Chip Cookie', 'Pastry', 4, 2.50, 10.00, 'Cash', 'Student'),
('TXN-20260114-016', '2026-01-14', 'Chai Latte', 'Tea', 1, 4.00, 4.00, 'Credit Card', 'Regular'),
('TXN-20260114-017', '2026-01-14', 'Caesar Salad', 'Food', 1, 7.50, 7.50, 'Mobile Pay', 'Walk-in'),
('TXN-20260114-018', '2026-01-14', 'Latte', 'Coffee', 1, 4.50, 4.50, 'Credit Card', 'Student'),
('TXN-20260114-019', '2026-01-14', 'Banana Bread', 'Pastry', 2, 3.50, 7.00, 'Cash', 'Regular'),
('TXN-20260114-020', '2026-01-14', 'Bottled Water', 'Other', 3, 2.00, 6.00, 'Mobile Pay', 'Walk-in'),

-- January 15, 2026 (20 transactions)
('TXN-20260115-001', '2026-01-15', 'Latte', 'Coffee', 2, 4.50, 9.00, 'Credit Card', 'Student'),
('TXN-20260115-002', '2026-01-15', 'Croissant', 'Pastry', 1, 3.50, 3.50, 'Mobile Pay', 'Regular'),
('TXN-20260115-003', '2026-01-15', 'Mocha', 'Coffee', 2, 5.00, 10.00, 'Credit Card', 'Walk-in'),
('TXN-20260115-004', '2026-01-15', 'Avocado Toast', 'Food', 1, 8.00, 8.00, 'Cash', 'Student'),
('TXN-20260115-005', '2026-01-15', 'Cappuccino', 'Coffee', 1, 4.50, 4.50, 'Credit Card', 'Regular'),
('TXN-20260115-006', '2026-01-15', 'Green Tea', 'Tea', 2, 2.50, 5.00, 'Mobile Pay', 'Walk-in'),
('TXN-20260115-007', '2026-01-15', 'Turkey Sandwich', 'Food', 2, 9.00, 18.00, 'Credit Card', 'Student'),
('TXN-20260115-008', '2026-01-15', 'Cold Brew', 'Coffee', 1, 4.00, 4.00, 'Cash', 'Regular'),
('TXN-20260115-009', '2026-01-15', 'Blueberry Muffin', 'Pastry', 2, 3.00, 6.00, 'Credit Card', 'Walk-in'),
('TXN-20260115-010', '2026-01-15', 'Espresso', 'Coffee', 3, 3.00, 9.00, 'Mobile Pay', 'Student'),
('TXN-20260115-011', '2026-01-15', 'Chai Latte', 'Tea', 1, 4.00, 4.00, 'Credit Card', 'Regular'),
('TXN-20260115-012', '2026-01-15', 'Cinnamon Roll', 'Pastry', 1, 4.00, 4.00, 'Cash', 'Walk-in'),
('TXN-20260115-013', '2026-01-15', 'Americano', 'Coffee', 2, 3.50, 7.00, 'Credit Card', 'Student'),
('TXN-20260115-014', '2026-01-15', 'Bagel with Cream Cheese', 'Food', 2, 4.50, 9.00, 'Mobile Pay', 'Regular'),
('TXN-20260115-015', '2026-01-15', 'Earl Grey', 'Tea', 1, 2.50, 2.50, 'Cash', 'Walk-in'),
('TXN-20260115-016', '2026-01-15', 'Chocolate Chip Cookie', 'Pastry', 2, 2.50, 5.00, 'Credit Card', 'Student'),
('TXN-20260115-017', '2026-01-15', 'Orange Juice', 'Other', 2, 3.50, 7.00, 'Credit Card', 'Regular'),
('TXN-20260115-018', '2026-01-15', 'Latte', 'Coffee', 1, 4.50, 4.50, 'Mobile Pay', 'Walk-in'),
('TXN-20260115-019', '2026-01-15', 'Caesar Salad', 'Food', 1, 7.50, 7.50, 'Cash', 'Student'),
('TXN-20260115-020', '2026-01-15', 'Banana Bread', 'Pastry', 1, 3.50, 3.50, 'Credit Card', 'Regular');
