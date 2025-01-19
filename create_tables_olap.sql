-- Create dimensions
-- Dimension: dim_date
CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL
);

-- Dimension: dim_category
CREATE TABLE dim_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Dimension: dim_product (SCD Type 2)
CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES dim_category(category_id),
    price INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    is_current BOOLEAN DEFAULT TRUE
);

-- Dimension: dim_customer
CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT
);

-- Dimension: dim_employee
CREATE TABLE dim_employee (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    hire_date DATE
);

-- Fact table: fact_sales
CREATE TABLE fact_sales (
    sales_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES dim_product(product_id),
    customer_id INT REFERENCES dim_customer(customer_id),
    date_id INT REFERENCES dim_date(date_id),
    quantity_sold INT NOT NULL,
    total_amount INT NOT NULL
);

-- Fact table: fact_inventory
CREATE TABLE fact_inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES dim_product(product_id),
    date_id INT REFERENCES dim_date(date_id),
    stock_quantity INT NOT NULL,
    restock_quantity INT NOT NULL
);
