-- ################# RUN IN OLAP DATABASE#####################################

-- Enable postgres_fdw (Foreign Data Wrapper) in OLAP db
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

drop foreign table if exists oltp_users;
drop foreign table if exists oltp_products;
drop foreign table if exists oltp_categories;
drop foreign table if exists oltp_orders;
drop foreign table if exists oltp_order_details;
drop user mapping if exists for CURRENT_USER SERVER oltp_server;
drop server if exists oltp_server;

-- Create connection to OLTP database
CREATE SERVER oltp_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'coffeeshop_otlp', port '5432');

-- Create user mapping for authentication
CREATE USER MAPPING FOR CURRENT_USER
SERVER oltp_server
OPTIONS (user 'andrei', password '1234');

-- Customers table (OLTP → OLAP)
create foreign table oltp_users(
    user_id int,
    name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT
) SERVER oltp_server
options (schema_name 'public', table_name 'users');

-- Products foreign table (OLTP → OLAP)
create foreign table oltp_products(
    product_id int,
    name TEXT,
    category_id int,
    price numeric
) SERVER oltp_server
options (schema_name 'public', table_name 'products');

-- Categories foreign table (OLTP → OLAP)
create foreign table oltp_categories (
    category_id int,
    category_name text
) server oltp_server
options (schema_name 'public', table_name 'categories');

-- Orders foreign table (OLTP → OLAP)
create foreign table oltp_orders (
    order_id int,
    user_id int,
    order_date timestamp,
    total_amount numeric
) SERVER oltp_server
options (schema_name 'public', table_name 'orders');

-- Order Details foreign table (OLTP → OLAP)
create foreign table oltp_order_details (
    order_id int,
    product_id int,
    quantity int,
    price numeric
) server oltp_server
options (schema_name 'public', table_name 'order_details');


-- Create function for OLTP trigger
drop function if exists run_etl_process();

create or replace function run_etl_process() returns void as $$
BEGIN
    -- Refresh OLAP tables before inserting new data
    truncate table dim_customer, dim_product, dim_category, dim_date, fact_inventory, fact_sales restart identity;

    -- Insert customers
    insert into dim_customer (customer_name, email, phone, address)
    select name, email, phone, address from oltp_users;

    -- Insert categories
    insert into dim_category (category_name)
    select distinct category_name from oltp_categories;

    -- Insert products
    insert into dim_product (product_name, category_id, price, start_date, end_date, is_current)
    select p.name, 
        c.category_id, 
        p.price, 
        NOW(),
        null,
        true
    from oltp_products p
    join dim_category c on p.category_id = c.category_id;

    -- Ensure dim_date is populated
    insert into dim_date (date, day, month, quarter, year)
    select distinct o.order_date, 
        EXTRACT(day from o.order_date),
        EXTRACT(month from o.order_date),
        EXTRACT(QUARTER from o.order_date),
        EXTRACT(year from o.order_date)
    from oltp_orders o
    where o.order_date not in (select date from dim_date);

    -- Insert sales transactions
    insert into fact_sales(product_id, customer_id, date_id, quantity_sold, total_amount)
    select od.product_id, 
        o.user_id, 
        d.date_id,  
        od.quantity, 
        od.price * od.quantity
    from oltp_orders o
    join oltp_order_details od on o.order_id = od.order_id
    join dim_date d on date(o.order_date) = date(d.date);
END;
$$ LANGUAGE plpgsql;

-- RUN ETL
select run_etl_process();

-- ###########################################################################




-- ################# RUN IN OLTP DATABASE ####################################
CREATE EXTENSION IF NOT EXISTS dblink;

drop trigger IF exists trigger_etl_on_order_insert on orders;
drop trigger IF exists trigger_etl_on_product_insert on products;
drop trigger IF exists trigger_etl_on_user_insert on users;
drop function if exists trigger_run_etl;

create or replace function trigger_run_etl() returns TRIGGER AS $$
BEGIN
    -- Use dblink_exec to call execute_etl() in OLAP without expecting a return value
	PERFORM * from dblink('dbname=coffeeshop_olap user=andrei password=1234', 'SELECT run_etl_process();') alias (res text);
    return null;
END;
$$ LANGUAGE plpgsql;


-- CREATE TRIGGERS
drop trigger IF exists trigger_etl_on_order_insert on orders;
drop trigger IF exists trigger_etl_on_product_insert on products;
drop trigger IF exists trigger_etl_on_user_insert on users;

-- Trigger for `orders` table
create trigger trigger_etl_on_order_insert
    after insert on orders
    for each statement
    execute function trigger_run_etl();

-- Trigger for `products` table
create trigger trigger_etl_on_product_insert
    after insert on products
    for each statement
    execute function trigger_run_etl();

-- Trigger for `users` table
create trigger trigger_etl_on_user_insert
    after insert on users
    for each statement
    execute function trigger_run_etl();
-- ###########################################################################


-- ################# TEST ETL OLTP -> OLAP ###################################
-- OLTP: Insert data into OLTP database
insert into products(name, description, price, category_id )
values ('Sacher 12', 'Traditional chocolate cake', 500, 7);

-- OLAP: Verify that the data has been inserted into OLAP database
select * from dim_product;

-- ###########################################################################
