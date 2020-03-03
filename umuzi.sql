CREATE DATABASE Umuzi;




-- I used VARCHAR for phone because i want it to be able to 
-- support numbers like +44856872553
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(50),
    address VARCHAR(200),
    phone VARCHAR(15),
    email VARCHAR(100),
    city VARCHAR(20),
    country VARCHAR(50)
);

INSERT INTO customers(first_name, last_name, gender, address, phone, email, city, country)
VALUES
    ('John', 'Hibert', 'Male', '284 chaucer st', '084789657', 'john@gmail.com', 'Johannesburg', 'South Africa'),
    ('Thando', 'Sithole', 'Female', '240 Sect 1', '0794445584', 'thando@gmail.com', 'Cape Town', 'South Africa'),
    ('Leon', 'Glen', 'Male', '81 Everton Rd, Gillits', '0820832830', 'Leon@gmail.com', 'Durban', 'South Africa'),
    ('Charl', 'Muller', 'Mul', '290A Dorset Ecke', '+44856872553', 'Charl.muller@yahoo.com', 'Berlin', 'Germany'),
    ('Julia', 'Stein', 'Female', '2 Wernerring', '+448672445058', 'Js234@yahoo.com', 'Frankfurt', 'Germany');

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    job_title VARCHAR(20)
);

INSERT INTO employees(first_name, last_name, email, job_title)
VALUES
    ('Kani', 'Mathews', 'mat@gmail.com', 'Manager'),
    ('Lesly', 'Cronje', 'LesC@gmail.com', 'Clerk'),
    ('Gideon', 'Maduku', 'm@gmail.com', 'Accountant');

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    description VARCHAR(300),
    buy_price NUMERIC
);

INSERT INTO products(product_name, description, buy_price)
VALUES
    ('Harley Davidson Chopper', 'This replica features working kickstand, front suspension, gear-shift lever', '150.75'),
    ('Classic Car', 'Turnable front wheels, steering function', '550.75'),
    ('Sports car', 'Turnable front wheels, steering function', '700.60');

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    amount NUMERIC
);

INSERT INTO payments(customer_id, payment_date, amount)
VALUES
    ('1', '01-09-2018', '150.75'),
    ('5', '03-09-2018', '150.75'),
    ('4', '03-09-2018', '700.60');

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    payment_id INTEGER REFERENCES payments(id),
    fulfilled_by_employee_id INTEGER REFERENCES employees(id),
    date_required TIMESTAMP,
    date_shipped TIMESTAMP,
    status VARCHAR(20)
);

INSERT INTO orders(product_id, payment_id, fulfilled_by_employee_id, date_required, date_shipped, status)
VALUES
    ('1', '1', '2', '05-09-2018', NULL, 'Not shipped'),
    ('1', '2', '2', '04-09-2018', '03-09-2018', 'Shipped'),
    ('3', '3', '3', '06-09-2018', NULL, 'Not shipped');


-- Part 2: Querying a database

-- Select ALL Records from cutomers table
SELECT * FROM customers;

-- Select only culumn with first_name and last_name as name on customers table
SELECT first_name || ' ' || last_name AS name FROM customers;

-- Show the name of the customer whose customer_id is 1
SELECT first_name || ' ' || last_name AS name 
FROM customers 
WHERE id=1;

-- UPDATE the record for customer_id = 1 on the customer table so that the name is "Lerato Mabitso"
UPDATE customers
set first_name = 'Lerato',
    last_name = 'Mabitso'
WHERE id=1

-- DELETE the record from customers table for customer 2 (customer_id=2)
DELETE FROM customers
WHERE id=2;

-- Select all unique statuses from the orders table and get a count of the number of orders for each unique status
SELECT
    DISTINCT status,
    COUNT(DISTINCT status)
FROM orders
GROUP BY
    status;

-- Return the MAXIMUM payment made on the payments table.
SELECT
    MAX(amount)
FROM payments;

-- Select all customers from the customers table, sorted by country column
SELECT *
FROM customers
ORDER BY
    country ASC;

SELECT *
FROM customers
ORDER BY
    country DESC;

-- Select all records from Products where the price is greater than 500
SELECT *
FROM products
WHERE buy_price>500;

-- Return the sum of the Amounts on the payments table
SELECT
    SUM(amount)
FROM payments;

-- Count the number of shipped orders in the orders table
SELECT
    COUNT(status)
FROM
    orders
WHERE
    status='Shipped';

-- Return the average price of all products, in rands and in dollars (assume exchange rate is 12 to the Dollar)
SELECT
    AVG(buy_price) AS Rand,
    AVG(buy_price/12) AS DOLLARS
FROM
    products;

-- Using INNER JOIN create a query that selects all Payments with Customer information
SELECT
    customers.id,
    customers.first_name,
    customers.last_name,
    customers.gender,
    customers.address,
    customers.phone,
    customers.email,
    customers.city,
    customers.country,
    payments.payment_date,
    payments.amount
FROM
    customers
INNER JOIN payments ON customers.id = payments.customer_id;


-- Select all products that have turnable front wheels
SELECT 
    *
FROM 
    products
WHERE
    description LIKE 'Turnable front wheels%';