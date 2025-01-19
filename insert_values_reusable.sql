-- Insert data to users table
INSERT INTO users (name, email, password, phone, address)
SELECT * FROM (VALUES
    ('Alice Smith', 'alice@example.com', 'password123', '1234567890', '123 Main St'),
    ('Bob Johnson', 'bob@example.com', 'password123', '1234567891', '456 Oak St'),
    ('Charlie Davis', 'charlie@example.com', 'password123', '1234567892', '789 Pine St'),
    ('Diana Evans', 'diana@example.com', 'password123', '1234567893', '321 Maple St'),
    ('Evan Foster', 'evan@example.com', 'password123', '1234567894', '654 Birch St'),
    ('Fiona Green', 'fiona@example.com', 'password123', '1234567895', '987 Cedar St'),
    ('George Harris', 'george@example.com', 'password123', '1234567896', '246 Elm St'),
    ('Hannah Ingram', 'hannah@example.com', 'password123', '1234567897', '135 Spruce St'),
    ('Ian Johnson', 'ian@example.com', 'password123', '1234567898', '579 Willow St'),
    ('Julia King', 'julia@example.com', 'password123', '1234567899', '864 Aspen St')
) AS new_data(name, email, password, phone, address)
WHERE NOT EXISTS (
    SELECT 1 FROM users u WHERE u.email = new_data.email
);

-- Insert data to categories table
INSERT INTO categories (category_name)
SELECT * FROM (VALUES
    ('Coffee'), ('Tea'), ('Pastries'), ('Sandwiches'), ('Smoothies'),
    ('Salads'), ('Snacks'), ('Desserts'), ('Breakfast'), ('Lunch')
) AS new_data(category_name)
WHERE NOT EXISTS (
    SELECT 1 FROM categories c WHERE c.category_name = new_data.category_name
);

-- Insert data to products table
INSERT INTO products (name, description, price, category_id)
SELECT * FROM (VALUES
    ('Espresso', 'Strong black coffee', 150, 1),
    ('Latte', 'Coffee with milk', 200, 1),
    ('Green Tea', 'Refreshing green tea', 120, 2),
    ('Croissant', 'Flaky buttery pastry', 180, 3),
    ('Ham Sandwich', 'Ham and cheese sandwich', 250, 4),
    ('Berry Smoothie', 'Mixed berry smoothie', 220, 5),
    ('Caesar Salad', 'Classic Caesar salad', 300, 6),
    ('Chocolate Bar', 'Sweet chocolate snack', 100, 7),
    ('Cheesecake', 'Creamy cheesecake slice', 350, 8),
    ('Pancakes', 'Fluffy pancakes with syrup', 270, 9)
) AS new_data(name, description, price, category_id)
WHERE NOT EXISTS (
    SELECT 1 FROM products p WHERE p.name = new_data.name AND p.description = new_data.description
);

-- Insert data to orders table
INSERT INTO orders (user_id, order_date, total_amount, status)
SELECT * FROM (VALUES
    (1, CURRENT_TIMESTAMP, 350, 'completed'),
    (2, CURRENT_TIMESTAMP, 500, 'pending'),
    (3, CURRENT_TIMESTAMP, 450, 'completed'),
    (4, CURRENT_TIMESTAMP, 600, 'shipped'),
    (5, CURRENT_TIMESTAMP, 300, 'pending'),
    (6, CURRENT_TIMESTAMP, 750, 'completed'),
    (7, CURRENT_TIMESTAMP, 400, 'cancelled'),
    (8, CURRENT_TIMESTAMP, 500, 'completed'),
    (9, CURRENT_TIMESTAMP, 650, 'shipped'),
    (10, CURRENT_TIMESTAMP, 200, 'completed')
) AS new_data(user_id, order_date, total_amount, status)
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = new_data.user_id AND o.order_date = new_data.order_date
);

-- Insert data to order_details table
INSERT INTO order_details (order_id, product_id, quantity, price)
SELECT * FROM (VALUES
    (1, 1, 2, 150), (1, 4, 1, 180), (2, 2, 1, 200), (2, 5, 2, 250),
    (3, 3, 2, 120), (3, 6, 1, 220), (4, 7, 1, 300), (4, 8, 2, 100),
    (5, 9, 1, 350), (5, 10, 1, 270)
) AS new_data(order_id, product_id, quantity, price)
WHERE NOT EXISTS (
    SELECT 1 FROM order_details od WHERE od.order_id = new_data.order_id AND od.product_id = new_data.product_id
);

-- Insert data to cart table
INSERT INTO cart (user_id, product_id, quantity)
SELECT * FROM (VALUES
    (1, 2, 1), (2, 3, 2), (3, 4, 1), (4, 5, 3),
    (5, 6, 1), (6, 7, 2), (7, 8, 1), (8, 9, 2),
    (9, 10, 1), (10, 1, 2)
) AS new_data(user_id, product_id, quantity)
WHERE NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.user_id = new_data.user_id AND c.product_id = new_data.product_id
);

-- Insert data to payments table
INSERT INTO payments (order_id, payment_date, amount, payment_method)
SELECT * FROM (VALUES
    (1, CURRENT_TIMESTAMP, 350, 'credit_card'), (2, CURRENT_TIMESTAMP, 500, 'paypal'),
    (3, CURRENT_TIMESTAMP, 450, 'cash'), (4, CURRENT_TIMESTAMP, 600, 'credit_card'),
    (5, CURRENT_TIMESTAMP, 300, 'cash'), (6, CURRENT_TIMESTAMP, 750, 'paypal'),
    (7, CURRENT_TIMESTAMP, 400, 'credit_card'), (8, CURRENT_TIMESTAMP, 500, 'cash'),
    (9, CURRENT_TIMESTAMP, 650, 'paypal'), (10, CURRENT_TIMESTAMP, 200, 'credit_card')
) AS new_data(order_id, payment_date, amount, payment_method)
WHERE NOT EXISTS (
    SELECT 1 FROM payments p WHERE p.order_id = new_data.order_id
);

-- Insert data to reviews table
INSERT INTO reviews (user_id, product_id, rating, comment, review_date)
SELECT * FROM (VALUES
    (1, 1, 5, 'Excellent coffee!', CURRENT_TIMESTAMP),
    (2, 2, 4, 'Tasty latte.', CURRENT_TIMESTAMP),
    (3, 3, 3, 'Good, but a bit bitter.', CURRENT_TIMESTAMP),
    (4, 4, 5, 'Amazing pastry!', CURRENT_TIMESTAMP),
    (5, 5, 4, 'Very filling.', CURRENT_TIMESTAMP)
) AS new_data(user_id, product_id, rating, comment, review_date)
WHERE NOT EXISTS (
    SELECT 1 FROM reviews r WHERE r.user_id = new_data.user_id AND r.product_id = new_data.product_id
);
