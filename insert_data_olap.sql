-- Load for dim_category
INSERT INTO dim_category (category_id, category_name)
VALUES
    (1, 'Coffee'),
    (2, 'Tea'),
    (3, 'Pastries'),
    (4, 'Sandwiches'),
    (5, 'Smoothies'),
    (6, 'Salads'),
    (7, 'Snacks'),
    (8, 'Desserts'),
    (9, 'Breakfast'),
    (10, 'Lunch');

-- Transform and Load for dim_product (SCD Type 2)
-- Insert new product and update price
INSERT INTO dim_product (product_id, product_name, category_id, price, start_date, end_date, is_current)
VALUES
    (1, 'Espresso', 1, 150, CURRENT_DATE, NULL, TRUE),
    (2, 'Latte', 1, 200, CURRENT_DATE, NULL, TRUE),
    (3, 'Green Tea', 2, 120, CURRENT_DATE, NULL, TRUE),
    (4, 'Croissant', 3, 180, CURRENT_DATE, NULL, TRUE),
    (5, 'Ham Sandwich', 4, 250, CURRENT_DATE, NULL, TRUE),
    (6, 'Berry Smoothie', 5, 220, CURRENT_DATE, NULL, TRUE),
    (7, 'Caesar Salad', 6, 300, CURRENT_DATE, NULL, TRUE),
    (8, 'Chocolate Bar', 7, 100, CURRENT_DATE, NULL, TRUE),
    (9, 'Cheesecake', 8, 350, CURRENT_DATE, NULL, TRUE),
    (10, 'Pancakes', 9, 270, CURRENT_DATE, NULL, TRUE);

-- Load data for dim_customer
INSERT INTO dim_customer (customer_id, customer_name, email, phone, address)
VALUES
    (1, 'Alice Smith', 'alice@example.com', '1234567890', '123 Main St'),
    (2, 'Bob Johnson', 'bob@example.com', '1234567891', '456 Oak St'),
    (3, 'Charlie Davis', 'charlie@example.com', '1234567892', '789 Pine St'),
    (4, 'Diana Evans', 'diana@example.com', '1234567893', '321 Maple St'),
    (5, 'Evan Foster', 'evan@example.com', '1234567894', '654 Birch St'),
    (6, 'Fiona Green', 'fiona@example.com', '1234567895', '987 Cedar St'),
    (7, 'George Harris', 'george@example.com', '1234567896', '246 Elm St'),
    (8, 'Hannah Ingram', 'hannah@example.com', '1234567897', '135 Spruce St'),
    (9, 'Ian Johnson', 'ian@example.com', '1234567898', '579 Willow St'),
    (10, 'Julia King', 'julia@example.com', '1234567899', '864 Aspen St');

-- Load data for dim_date
INSERT INTO dim_date (date_id, date, day, month, quarter, year)
VALUES
    (1, CURRENT_DATE, EXTRACT(DAY FROM CURRENT_DATE),
     EXTRACT(MONTH FROM CURRENT_DATE),
     EXTRACT(QUARTER FROM CURRENT_DATE),
     EXTRACT(YEAR FROM CURRENT_DATE)),
    (2, CURRENT_DATE - INTERVAL '1 day', EXTRACT(DAY FROM CURRENT_DATE - INTERVAL '1 day'),
     EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 day'),
     EXTRACT(QUARTER FROM CURRENT_DATE - INTERVAL '1 day'),
     EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 day')),
    (3, CURRENT_DATE - INTERVAL '2 day', EXTRACT(DAY FROM CURRENT_DATE - INTERVAL '2 day'),
     EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '2 day'),
     EXTRACT(QUARTER FROM CURRENT_DATE - INTERVAL '2 day'),
     EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '2 day'));

-- Load data for fact_sales
INSERT INTO fact_sales (product_id, customer_id, date_id, quantity_sold, total_amount)
VALUES
    (1, 1, 1, 2, 300),
    (2, 2, 2, 1, 200),
    (3, 3, 3, 3, 360),
    (4, 4, 1, 1, 180),
    (5, 5, 2, 2, 500),
    (6, 6, 3, 1, 220),
    (7, 7, 1, 4, 1200),
    (8, 8, 2, 2, 200),
    (9, 9, 3, 1, 350),
    (10, 10, 1, 3, 810);

-- Load dat for fact_inventory
INSERT INTO fact_inventory (product_id, date_id, stock_quantity, restock_quantity)
VALUES
    (1, 1, 50, 20),
    (2, 2, 40, 10),
    (3, 3, 30, 15),
    (4, 1, 60, 25),
    (5, 2, 45, 20),
    (6, 3, 35, 10),
    (7, 1, 20, 5),
    (8, 2, 8, 5),
    (9, 3, 50, 30),
    (10, 1, 40, 20);

-- Load data for dim_employee
INSERT INTO dim_employee (employee_id, employee_name, position, hire_date)
VALUES
    (1, 'John Doe', 'Barista', CURRENT_DATE - INTERVAL '500 day'),
    (2, 'Jane Smith', 'Manager', CURRENT_DATE - INTERVAL '400 day'),
    (3, 'Mike Johnson', 'Cashier', CURRENT_DATE - INTERVAL '300 day'),
    (4, 'Emily Davis', 'Chef', CURRENT_DATE - INTERVAL '200 day'),
    (5, 'Robert Brown', 'Waiter', CURRENT_DATE - INTERVAL '100 day'),
    (6, 'Linda Wilson', 'Cleaner', CURRENT_DATE - INTERVAL '150 day'),
    (7, 'James White', 'Barista', CURRENT_DATE - INTERVAL '350 day'),
    (8, 'Laura Miller', 'Manager', CURRENT_DATE - INTERVAL '250 day'),
    (9, 'Daniel Harris', 'Cashier', CURRENT_DATE - INTERVAL '450 day'),
    (10, 'Sophia Clark', 'Chef', CURRENT_DATE - INTERVAL '600 day');
