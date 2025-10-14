    --Dariya Yergaliyeva 24B031743
--part1
--task1.1
CREATE TABLE employees5 (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK ( age BETWEEN 18 and 65),
    salary NUMERIC CHECK ( salary > 0 )
);
--task1.2
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC CHECK ( regular_price > 0 ),
    discount_price NUMERIC CHECK ( discount_price > 0 AND discount_price < regular_price),
    CONSTRAINT valid_discount CHECK (discount_price < regular_price)
);
--task1.3
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE CHECK ( check_out_date > check_in_date ),
    num_guests INTEGER CHECK ( num_guests between 1 AND 10)
);
--task1.4
-- Valid data
INSERT INTO employees5 (employee_id, first_name, last_name, age, salary)
VALUES (1, 'Kamila', 'Yertiskyzy', 19, 50000);

-- Invalid data (age out of range, salary is zero or negative)
INSERT INTO employees5 (employee_id, first_name, last_name, age, salary)
VALUES (2, 'Egor', 'Fedorov', 14, -8000);
--Valid data
INSERT INTO products_catalog (product_id, product_name, regular_price, discount_price)
VALUES (1, 'Calculator', 1000, 200);
--Invalid data (discount_price is greater than regular_price, regular_price is zero or negative)
INSERT INTO products_catalog (product_id, product_name, regular_price, discount_price)
VALUES (2, 'Magnit', -11, 900);
--Valid data
INSERT INTO bookings (booking_id, check_in_date, check_out_date, num_guests)
VALUES (1, '2025-10-01', '2025-10-10', 5);

-- Invalid data (num_guests is outside the valid range, check_out_date is before check_in_date)
INSERT INTO bookings (booking_id, check_in_date, check_out_date, num_guests)
VALUES (2, '2025-10-15', '2025-10-10', 15);
--part2
--task2.1
CREATE TABLE customers5 (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);
--task2.2
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK ( quantity >= 0 ),
    unit_price NUMERIC NOT NULL CHECK ( unit_price > 0 ),
    last_updated TIMESTAMP NOT NULL
);
--task2.3
-- Valid data
INSERT INTO customers5 (customer_id, email, phone, registration_date)
VALUES (1, 'john@example.com', '123456789', '2025-10-09');

-- Invalid data (NULL in NOT NULL column)
INSERT INTO customers5 (customer_id, email, phone, registration_date)
VALUES (2, NULL, '987654321', NULL);

--Valid data
INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (1, 'Laptop', 8, 500000, NOW());
--Invalid date
INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (1, NULL, NULL, NULL, NULL);

--part3
--task3.1
CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);
--task3.2
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER UNIQUE ,
    course_code TEXT UNIQUE ,
    semester TEXT UNIQUE
);
--task3.3
ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE (username),
ADD CONSTRAINT unique_email UNIQUE (email);

--part4
--task4.1
CREATE TABLE departments5 (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);
ALTER TABLE departments
ADD COLUMN location TEXT;

INSERT INTO departments (dept_id, dept_name, location)
VALUES (1, 'HR', 'Astana');

INSERT INTO departments (dept_id, dept_name, location)
VALUES (2, 'Finance', 'Almaty');

INSERT INTO departments (dept_id, dept_name, location)
VALUES (3, 'Engineering', 'Almaty');
--invalid
INSERT INTO departments (dept_id, dept_name, location)
VALUES (1, 'Marketing', 'Karaganda');
INSERT INTO departments (dept_id, dept_name, location)
VALUES (NULL, 'Sales', 'Karaganda');
--task4.2
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);
--task4.3
--Difference between UNIQUE and PRIMARY KEY:
--A PRIMARY KEY is a column or a combination of columns that uniquely identify a record in a table. It does not allow NULL values.
--A UNIQUE constraint ensures that all values in a column (or combination of columns) are unique, but it allows NULL values.
--When to use a single-column vs. composite PRIMARY KEY:
--Use a single-column PRIMARY KEY when one column alone can uniquely identify a record, like employee_id.
--Use a composite PRIMARY KEY when no single column can uniquely identify a record, and you need a combination of columns.
--Why a table can have only one PRIMARY KEY but multiple UNIQUE constraints:
--A table can only have one PRIMARY KEY because it defines the unique identity of each row. However, it can have multiple UNIQUE constraints to ensure other combinations of columns also remain unique.

--part5
--task5.1
CREATE TABLE employee_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments,
    hire_date DATE
);
INSERT INTO employee_dept (emp_id, emp_name, dept_id, hire_date)
VALUES (1, 'Alice', 1, '2025-10-10');

INSERT INTO employee_dept (emp_id, emp_name, dept_id, hire_date)
VALUES (2, 'Alinur', 99, '2025-10-10');

--task5.2
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL
);
CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);
CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors,
    publisher_id INTEGER REFERENCES publishers,
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

ALTER TABLE authors
ADD COLUMN country TEXT;
INSERT INTO authors (author_id, author_name, country)
VALUES (1, 'J.K. Rowling', 'United Kingdom');

INSERT INTO authors (author_id, author_name, country)
VALUES (2, 'George Orwell', 'United Kingdom');

INSERT INTO publishers (publisher_id, publisher_name, city)
VALUES (1, 'Bloomsbury', 'London');

INSERT INTO publishers (publisher_id, publisher_name, city)
VALUES (2, 'Secker & Warburg', 'London');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn)
VALUES (1, 'Harry Potter and the Philosopher', 1, 1, 1997, '9780747532699');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn)
VALUES (2, 'Nineteen Eighty-Four', 2, 2, 1949, '9780451524935');

--task5.3
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);
CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories ON DELETE RESTRICT
);
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);
CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk,
    quantity INTEGER CHECK ( quantity > 0 )
);
INSERT INTO categories (category_id, category_name)
VALUES (1, 'Electronics');

INSERT INTO products_fk (product_id, product_name, category_id)
VALUES (1, 'Laptop', 1);

INSERT INTO categories (category_id, category_name)
VALUES (2, 'Clothing');

INSERT INTO products_fk (product_id, product_name, category_id)
VALUES (2, 'Laptop', 1), (3, 'Shirt', 2);

INSERT INTO orders (order_id, order_date)
VALUES (1, '2025-10-01'), (2, '2025-10-02');

INSERT INTO order_items (item_id, order_id, product_id, quantity)
VALUES (1, 1, 1, 2), (2, 1, 2, 1), (3, 2, 3, 3);

DELETE FROM categories WHERE category_id = 1;

DELETE FROM orders WHERE order_id = 1;

--RESTRICT: This option prevents the deletion of a row in the parent table if there are any corresponding rows in the child table.
-- In this case, we used RESTRICT in the products table for category_id, so deleting a category that has products will fail.

--CASCADE: This option deletes all rows in the child table that reference the deleted row in the parent table.
-- In this case, we used CASCADE in the order_items table, so when an order is deleted, all associated order items are also deleted automatically.

--part6
--task6.1
CREATE TABLE customers66 (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL ,
    phone TEXT NOT NULL,
    registration_date DATE NOT NULL
);
CREATE TABLE products66 (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC CHECK ( price >= 0 ),
    stock_quantity INTEGER CHECK ( stock_quantity >= 0 )
);
CREATE TABLE orders66 (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers66 ON DELETE CASCADE,
    order_date DATE NOT NULL,
    total_amount NUMERIC CHECK ( total_amount >= 0 ),
    status TEXT CHECK ( status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);
CREATE TABLE order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders66 ON DELETE CASCADE,
    product_id INTEGER REFERENCES products66 ON DELETE CASCADE,
    quantity INTEGER CHECK ( quantity >= 0 ),
    unit_price NUMERIC CHECK ( unit_price >= 0 )
);
--customer valid insert
INSERT INTO customers66 (customer_id, name, email, phone, registration_date)
VALUES (1, 'Amina Asset', 'amina@gmail.com', '1234567890', '2025-10-01');

INSERT INTO customers66 (customer_id, name, email, phone, registration_date)
VALUES (2, 'Alua Sam', 'alua@gmail.com', '0987654321', '2025-10-02');

--products valid insert
INSERT INTO products66 (product_id, name, description, price, stock_quantity)
VALUES (1, 'Laptop', 'High-performance laptop', 1000, 50);

INSERT INTO products66 (product_id, name, description, price, stock_quantity)
VALUES (2, 'Smartphone', 'Latest smartphone model', 700, 100);

INSERT INTO products66 (product_id, name, description, price, stock_quantity)
VALUES (3, 'Headphones', 'Noise-cancelling headphones', 150, 200);

--orders valid insert
INSERT INTO orders66 (order_id, customer_id, order_date, total_amount, status)
VALUES (1, 1, '2025-10-03', 1500, 'pending');

INSERT INTO orders66 (order_id, customer_id, order_date, total_amount, status)
VALUES (2, 2, '2025-10-04', 700, 'shipped');

--order details valid insert
INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES (1, 1, 1, 1, 1000);

INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES (2, 1, 3, 2, 150);

INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES (3, 2, 2, 1, 700);

-- invalid: email must be unique
INSERT INTO customers66 (customer_id, name, email, phone, registration_date)
VALUES (3, 'Alic', 'amina@gmail.com', '5556667777', '2025-10-05');

-- invalid: price must be >= 0
INSERT INTO products66 (product_id, name, description, price, stock_quantity)
VALUES (4, 'Headphones', 'jbl', -80, 10);

-- invalid: status must be one of 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
INSERT INTO orders66 (order_id, customer_id, order_date, total_amount, status)
VALUES (3, 1, '2025-10-05', 500, 'idk');