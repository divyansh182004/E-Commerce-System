create database PROJECT;
use project;


/* TABLE NO 1 */


CREATE TABLE customer(
		customer_id int primary key auto_increment,
        first_name varchar (200) not null,
        last_name varchar (200) not null,
        email varchar(255) unique not null,
        contact_no bigint,
        city varchar(100) not null,
         registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO customer
(customer_id, first_name, last_name, email, contact_no, city, registration_date)
VALUES
(1, 'Rahul', 'Sharma', 'rahul.sharma@email.com', '9876543210', 'Delhi', '2025-12-15 10:30:00'),
(2, 'Priya', 'Patel', 'priya.patel@email.com', '9876543211', 'Mumbai', '2026-01-10 14:20:00'),
(3, 'Amit', 'Kumar', 'amit.kumar@email.com', '9876543212', 'Bangalore', '2026-01-25 09:45:00'),
(4, 'Sneha', 'Singh', 'sneha.singh@email.com', '9876543213', 'Chennai', '2026-02-05 16:15:00'),
(5, 'Vikram', 'Reddy', 'vikram.reddy@email.com', '9876543214', 'Hyderabad', '2026-02-20 11:00:00'),
(6, 'Anjali', 'Mehta', 'anjali.mehta@email.com', '9876543215', 'Pune', '2026-03-01 13:30:00'),
(7, 'Neha', 'Verma', 'neha.verma@email.com', '9876543216', 'Jaipur', '2026-03-02 09:10:00'),
(8, 'Deepak', 'Jain', 'deepak.jain@email.com', '9876543217', 'Ahmedabad', '2026-02-18 18:25:00'),
(9, 'Ritu', 'Agarwal', 'ritu.agarwal@email.com', '9876543218', 'Indore', '2026-02-22 08:40:00'),
(10, 'Saurabh', 'Mishra', 'saurabh.mishra@email.com', '9876543219', 'Lucknow', '2026-02-27 20:05:00'),
(11, 'Kunal', 'Gupta', 'kunal.gupta@email.com', '9876543220', 'Noida', '2026-03-03 12:55:00'),
(12, 'Pooja', 'Chopra', 'pooja.chopra@email.com', '9876543221', 'Surat', '2026-03-04 10:45:00');


/* TABLE NO 2 */

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);
INSERT INTO categories (category_id, category_name, description)
VALUES
(1, 'Electronics', 'Electronic devices and gadgets'),
(2, 'Clothing', 'Apparel and fashion items'),
(3, 'Books', 'Books and educational materials'),
(4, 'Home & Kitchen', 'Home appliances and kitchenware'),
(5, 'Sports', 'Sports equipment and accessories');


/* TABLE NO 3 */

CREATE TABLE products (
		product_id int primary key auto_increment,
        product_name varchar(200) not null,
        category_id int not null,
        price decimal (10,2) not null check (price >0),
        stock_quantity int not null default 0 check (stock_quantity >=0),
        is_active BOOLEAN NOT NULL DEFAULT TRUE,
        CREATED_DATE DATETIME default current_timestamp,
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
INSERT INTO products
(product_id, product_name, category_id, price, stock_quantity, is_active, created_date)
VALUES
(1, 'iPhone 15 Pro', 1, 129999.00, 15, 1, '2025-12-20 10:00:00'),
(2, 'Samsung Galaxy S24', 1, 89999.00, 20, 1, '2025-12-22 11:00:00'),
(3, 'Sony Headphones WH-1000XM5', 1, 29999.00, 30, 1, '2025-12-25 12:00:00'),
(4, 'Dell XPS 15 Laptop', 1, 145000.00, 10, 1, '2026-01-05 09:00:00'),
(5, 'Apple Watch Series 9', 1, 45999.00, 25, 1, '2026-01-08 15:00:00'),
(6, 'Levi''s Jeans', 2, 2999.00, 100, 1, '2026-01-10 10:00:00'),
(7, 'Nike Running Shoes', 2, 5999.00, 50, 1, '2026-01-12 10:00:00'),
(8, 'Adidas T-Shirt', 2, 1299.00, 150, 1, '2026-01-15 10:00:00'),
(9, 'The Psychology of Money', 3, 399.00, 80, 1, '2026-01-18 10:00:00'),
(10, 'Atomic Habits', 3, 499.00, 60, 1, '2026-01-18 10:05:00'),
(11, 'Thinking Fast and Slow', 3e, 699.00, 40, 1, '2026-01-18 10:10:00'),
(12, 'Air Fryer', 4, 4999.00, 35, 1, '2026-01-20 10:00:00'),
(13, 'Mixer Grinder', 4, 3499.00, 45, 1, '2026-01-20 10:05:00'),
(14, 'Pressure Cooker', 4, 2299.00, 55, 1, '2026-01-20 10:10:00'),
(15, 'Cricket Bat', 5, 1899.00, 25, 1, '2026-01-22 10:00:00'),
(16, 'Football', 5, 899.00, 40, 1, '2026-01-22 10:05:00'),
(17, 'Bluetooth Speaker', 1, 2499.00, 60, 1, '2026-01-25 11:00:00'),
(18, 'Wireless Mouse', 1, 999.00, 120, 1, '2026-01-26 11:30:00'),
(19, 'Gaming Keyboard', 1, 3499.00, 40, 1, '2026-01-27 12:00:00'),
(20, 'Formal Shirt', 2, 1999.00, 80, 1, '2026-01-28 10:00:00'),
(21, 'Woolen Jacket', 2, 3999.00, 30, 1, '2026-01-29 10:30:00'),
(22, 'Cookbook: Indian Recipes', 3, 599.00, 70, 1, '2026-01-30 09:45:00'),
(23, 'Wall Clock', 4, 1299.00, 90, 1, '2026-01-31 16:00:00'),
(24, 'Badminton Racket', 5, 1599.00, 35, 1, '2026-02-01 17:30:00');

select * from customer;

/* TABLE NO 4 */

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    contact_no VARCHAR(20)
);
INSERT INTO suppliers
(supplier_id, supplier_name, contact_email, city, contact_no)
VALUES
(1, 'TechCorp India', 'sales@techcorp.in', 'Delhi', '011-12345678'),
(2, 'FashionHub Distributors', 'orders@fashionhub.in', 'Mumbai', '022-87654321'),
(3, 'BookWorld Wholesale', 'supply@bookworld.in', 'Bangalore', '080-11223344'),
(4, 'HomeEssentials Ltd', 'contact@homeessentials.in', 'Chennai', '044-99887766'),
(5, 'SportsPro Suppliers', 'info@sportspro.in', 'Pune', '020-55443322');


/* TABLE NO 5 */

create table orders(
		order_id int primary key auto_increment,
        customer_id int not null,
        order_date datetime default current_timestamp,
        total_amount decimal (10,2) default 0 check (total_amount >=0),
        order_status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED') 
        DEFAULT 'PENDING',
        foreign key(customer_id) references customer(customer_id) on update cascade on delete cascade,
		 INDEX idx_orders_customer (customer_id),
    INDEX idx_orders_date (order_date)
);
INSERT INTO orders
(order_id, customer_id, order_status, order_date, total_amount)
VALUES
(1, 1, 'DELIVERED', '2026-01-20 10:15:00', 159998.00),
(2, 1, 'DELIVERED', '2026-02-05 14:30:00', 29999.00),
(3, 2, 'SHIPPED', '2026-02-15 09:45:00', 145000.00),
(4, 2, 'DELIVERED', '2026-02-20 16:20:00', 8997.00),
(5, 3, 'DELIVERED', '2026-02-25 11:30:00', 1697.00),
(6, 3, 'PROCESSING', '2026-03-01 13:15:00', 89999.00),
(7, 4, 'CANCELLED', '2026-02-28 10:00:00', 45999.00),
(8, 4, 'DELIVERED', '2026-03-02 15:45:00', 5999.00),
(9, 5, 'PENDING', '2026-03-04 12:30:00', 7798.00),
(10, 5, 'DELIVERED', '2026-02-18 17:00:00', 129999.00),
(11, 6, 'SHIPPED', '2026-03-05 09:00:00', 129999.00),
(12, 2, 'DELIVERED', '2026-03-06 10:20:00', 14997.00),
(13, 3, 'DELIVERED', '2026-03-06 15:05:00', 1198.00),
(14, 4, 'SHIPPED', '2026-03-07 11:30:00', 8498.00),
(15, 5, 'DELIVERED', '2026-03-07 18:45:00', 4598.00),
(16, 6, 'PENDING', '2026-03-08 09:10:00', 3697.00),
(17, 7, 'DELIVERED', '2026-03-08 20:25:00', 129999.00),
(18, 8, 'DELIVERED', '2026-03-09 14:15:00', 119998.00),
(19, 9, 'PROCESSING', '2026-03-09 19:40:00', 145000.00),
(20, 10, 'DELIVERED', '2026-03-10 08:55:00', 1597.00);


/* TABLE NO 6 */

create table orders_items(
		order_item_id int primary key auto_increment unique,
        order_id int not null,
		product_id int not null,
        quantity int not null check ( quantity >0),
        unit_price DECIMAL(10, 2) NOT NULL,
        line_total DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
        foreign key(order_id) references orders(order_id) on update cascade on delete cascade,
        foreign key(product_id) references products(product_id) on update cascade on delete restrict,
		INDEX idx_order_items_order_id (order_id),
		INDEX idx_order_items_product_id (product_id)
);
select * from orders_items;
INSERT INTO orders_items
(order_item_id, order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 1, 129999.00),
(2, 1, 3, 1, 29999.00),
(3, 2, 3, 1, 29999.00),
(4, 3, 4, 1, 145000.00),
(5, 4, 6, 3, 2999.00),
(6, 5, 9, 2, 399.00),
(7, 5, 16, 1, 899.00),
(8, 6, 2, 1, 89999.00),
(9, 7, 5, 1, 45999.00),
(10, 8, 7, 1, 5999.00),
(11, 9, 12, 1, 4999.00),
(12, 9, 13, 1, 2799.00),
(13, 10, 1, 1, 129999.00),
(14, 11, 1, 1, 129999.00),
(15, 12, 7, 2, 5999.00),
(16, 12, 6, 1, 2999.00),
(17, 13, 10, 1, 499.00),
(18, 13, 11, 1, 699.00),
(19, 14, 12, 1, 4999.00),
(20, 14, 13, 1, 3499.00),
(21, 15, 14, 2, 2299.00),
(22, 16, 15, 1, 1899.00),
(23, 16, 16, 2, 899.00),
(24, 17, 1, 1, 129999.00),
(25, 18, 2, 1, 89999.00),
(26, 18, 3, 1, 29999.00),
(27, 19, 4, 1, 145000.00),
(28, 20, 9, 1, 399.00),
(29, 20, 10, 1, 499.00),
(30, 20, 11, 1, 699.00);

select * from orders_items;
/* TABLE NO 7 */

CREATE TABLE PURCHASE_ORDERS(
		purchase_id int primary key auto_increment unique,
        supplier_id int not null,
        purchase_date datetime default current_timestamp,
        total_cost decimal (10,2) default 0 check (total_cost >=0),
        status enum ('RECEIVED','PENDING') default 'PENDING',
        foreign key(supplier_id) references suppliers(supplier_id) on update cascade on delete restrict,
        INDEX idx_PURCHASE_ORDERS_purchase_date (purchase_date),
        INDEX idx_PURCHASE_ORDERS_supplier_id (supplier_id)
);
INSERT INTO purchase_orders
(purchase_id, supplier_id, purchase_date, total_cost, status)
VALUES
(1, 1, '2026-01-05 09:00:00', 2725000.00, 'RECEIVED'),
(2, 2, '2026-01-15 10:30:00', 307000.00, 'RECEIVED'),
(3, 3, '2026-02-01 11:00:00', 36000.00, 'RECEIVED'),
(4, 4, '2026-02-10 14:30:00', 247000.00, 'RECEIVED'),
(5, 5, '2026-02-25 15:00:00', 41500.00, 'PENDING');


/* TABLE NO 8 */

create table PURCHASE_ITEMS(
		purchase_item_id int primary key auto_increment unique,
        purchase_id int not null,
        product_id int not null,
        quantity int default 0 check (quantity >=0),
        unit_cost DECIMAL(10,2) NOT NULL CHECK (unit_cost >= 0),
        line_cost DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * unit_cost) STORED,
        foreign key(purchase_id) references PURCHASE_ORDERS(purchase_id) on update cascade
        on delete cascade,
        foreign key(product_id) references products(product_id) on update cascade 
        on delete restrict
);
select * from purchase_items;

INSERT INTO purchase_items
(purchase_item_id, purchase_id, product_id, quantity, unit_cost)
VALUES
(1, 1, 1, 10, 110000.00),
(2, 1, 2, 15, 75000.00),
(3, 1, 3, 20, 25000.00),
(4, 2, 6, 50, 2000.00),
(5, 2, 7, 30, 4500.00),
(6, 2, 8, 80, 900.00),
(7, 3, 9, 40, 300.00),
(8, 3, 10, 30, 400.00),
(9, 3, 11, 20, 600.00),
(10, 4, 12, 25, 4000.00),
(11, 4, 13, 30, 2800.00),
(12, 4, 14, 35, 1800.00),
(13, 5, 15, 15, 1600.00),
(14, 5, 16, 25, 700.00);