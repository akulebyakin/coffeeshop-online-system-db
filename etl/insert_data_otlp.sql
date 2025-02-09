-- ETL process to upload data from CSV to OTLP database

-- Drop temp tables if exist
drop table if exists temp_users;
drop table if exists temp_products;
drop table if exists temp_orders;
drop table if exists temp_order_details;
drop table if exists temp_reviews;
drop table if exists temp_cart;
drop table if exists temp_inserted_orders;

-- Create temp tables - they needed for storing tempopary data from CSV
create TEMP table temp_users (name TEXT, email TEXT, password TEXT, phone TEXT, address TEXT);
create TEMP table temp_products (name TEXT, description TEXT, price numeric, category_name TEXT);
create TEMP table temp_orders (user_email TEXT, total_price numeric, status TEXT, order_date timestamp, payment_date timestamp, payment_method TEXT);
create TEMP table temp_order_details (user_email TEXT, order_date timestamp, product TEXT, price_per_product numeric, quantity int);
create TEMP table temp_reviews (user_email TEXT, product TEXT, rating int, comment TEXT, review_date timestamp);
create TEMP table temp_cart (user_email TEXT, product TEXT, quantity int);

-- Load data to temp tables
COPY temp_users from '/Users/andrei/projects/coffeeshop-online-system-db/new_csv/users.csv' DELIMITER ',' CSV HEADER;
COPY temp_products from '/Users/andrei/projects/coffeeshop-online-system-db/new_csv/products.csv' DELIMITER ',' CSV HEADER;
COPY temp_orders from '/Users/andrei/projects/coffeeshop-online-system-db/new_csv/orders.csv' DELIMITER ',' CSV HEADER;
COPY temp_order_details from '/Users/andrei/projects/coffeeshop-online-system-db/new_csv/order_details.csv' DELIMITER ',' CSV HEADER;
COPY temp_reviews from '/Users/andrei/projects/coffeeshop-online-system-db/new_csv/reviews.csv' DELIMITER ',' CSV HEADER;
COPY temp_cart from '/Users/andrei/projects/coffeeshop-online-system-db/new_csv/cart.csv' DELIMITER ',' CSV HEADER;

-- Clear main tables before inserting new data from CSV
truncate table users, cart, categories, products, orders, order_details, payments, reviews restart identity;

-- Insert users
insert into users(name, email, password, phone, address)
select name, email, password, phone, address from temp_users;

-- Insert product categories
insert into categories (category_name) select distinct category_name from temp_products;

-- Insert products
insert into products(name, description, price, category_id)
select  p.name,
    p.description,
    p.price,
    c.category_id
from temp_products p join categories c on p.category_name = c.category_name;

-- Insert orders
insert into orders(user_id, order_date, total_amount, status)
select u.user_id,
	o.order_date,
	o.total_price,
	o.status
from temp_orders o  join users u on o.user_email = u.email;

-- Insert order details
insert into order_details (order_id, product_id,quantity, price)
select o.order_id,
    p.product_id,
    od.quantity,od.price_per_product
from temp_order_details od
join orders o
	on o.user_id = (select user_id from users where email = od.user_email)
	    and o.order_date = od.order_date
join products p on od.product = p.name;

-- Insert payments
insert into payments(order_id,payment_date, amount, payment_method)
select o.order_id,
    tto.payment_date,
    tto.total_price,
    tto.payment_method
from temp_orders tto
join orders o
    on o.user_id = (select user_id from users where users.email = tto.user_email)
    and o.order_date = tto.order_date;

-- Insert reviews
insert into reviews(user_id,product_id, rating, comment,  review_date )
select u.user_id,
    p.product_id,
    r.rating,
    r.comment,
    r.review_date
from temp_reviews r
    join users u on r.user_email = u.email
    join products p on r.product = p.name;

-- Insert cart products
insert into cart(user_id, product_id,quantity)
select u.user_id,
    p.product_id,
    c.quantity
from temp_cart c
    join users u on c.user_email = u.email
    join products p on c.product = p.name;
