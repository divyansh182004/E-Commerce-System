use project;
/* Q1 */
alter table products add column
percentage_discount numeric default 0 check ( percentage_discount >=0);
/* Q2 */
CREATE INDEX idx_orders_order_date ON orders (order_date);
/* Q3 */
ALTER TABLE orders ADD COLUMN delivery_date DATETIME NULL;
/* Q4 */
ALTER TABLE customer ADD CONSTRAINT chk_phone_not_empty
check(contact_no is null or trim(contact_no) <> '');
/* Q5 */

CREATE TABLE PRODUCT_REVIEWS(
		review_id int primary key auto_increment,
        product_id int not null,
        customer_id int not null,
        rating enum ('1','2','3','4','5'),
        review_text varchar(255),
        review_date datetime default current_timestamp,
        foreign key(product_id) references products(product_id),
        foreign key(customer_id) references customer(customer_id)
);
select * from product_reviews;
/* Q6/A) */
DELETE FROM categories
WHERE category_id = 1;

/*B) cannot delete because of foreign key constraint is there. */

SHOW CREATE TABLE purchase_items;

/* Q7 */
ALTER TABLE purchase_orders
DROP FOREIGN KEY purchase_orders_ibfk_1;

ALTER TABLE purchase_orders
ADD CONSTRAINT purchase_orders_ibfk_1
FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE purchase_items
DROP FOREIGN KEY purchase_items_ibfk_1;

ALTER TABLE purchase_items
ADD CONSTRAINT purchase_items_ibfk_1
FOREIGN KEY (purchase_id)
REFERENCES purchase_orders(purchase_id)
ON UPDATE CASCADE ON DELETE CASCADE;

/* Q8 Empty all data from order_items while keeping the table structure.*/
/* truncate command is a good idea to use for deleting all the rows at once instead of using delete
becuase delete command delete each row line by line and truncate command delete all the rows
in once */

/* DML QUESTIONS */
/* Q9 Increase the discount for all products in the “Electronics” category to 10%.*/
UPDATE products
SET percentage_discount = 10
WHERE category_id = (
    SELECT category_id
    FROM categories
    WHERE category_name = 'Electronics'
);
/* Q9-B Use of join between products and categories.*/
SELECT 
    c.category_id,
    c.category_name,
    p.product_id,
    p.product_name,
    p.price
FROM 
    categories c
LEFT JOIN 
    products p 
    ON c.category_id = p.category_id;

/* Q10-Insert a new order for an existing customer with two order_items:*/

INSERT INTO orders (customer_id, order_status, total_amount) VALUES (1, 'PENDING', 160.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES 
(101, 2, 2, 50.00, 100.00),
(101, 3, 3, 20.00, 60.00);

/*Q11-Change PENDING orders older than 7 days to CANCELLED*/
UPDATE orders 
SET order_status = 'CANCELLED' 
WHERE order_status = 'PENDING' AND order_date < NOW() - INTERVAL 7 DAY;

/*Q12. Remove cancelled orders placed before 2026-03-01*/
DELETE FROM orders 
WHERE order_status = 'CANCELLED' AND order_date < '2026-03-01';

/*Q13-Increase stock by 10 for products with stock < 20*/
UPDATE products
SET stock_quantity = stock_quantity + 10
where stock_quantity < 20;

/*Q14. Insert a new purchase order with three purchase items SQL*/
INSERT INTO purchase_orders (supplier_id, status, total_cost) VALUES (1, 'RECEIVED', 250.00);

INSERT INTO purchase_items (purchase_id, product_id, quantity, unit_cost) 
VALUES
(1, 1, 10, 10.00),
(1, 2, 5, 20.00),
(1, 3, 5, 10.00);

/*Q15. Deactivate products with zero stock*/
UPDATE products 
SET is_active = FALSE 
WHERE stock_quantity = 0;

/*Q16. Remove purchase items for PENDING purchase orders older than 30 days*/

DELETE pi FROM purchase_items pi
JOIN purchase_orders po ON pi.purchase_id = po.purchase_id
WHERE po.status = 'PENDING' AND po.purchase_date < NOW() - INTERVAL 30 DAY;

-- 17. For all orders, show:
--  o order_id, order_date, order_status, total_amount,
--  o customer full name, customer email.
--  o Use a join between orders and customers.
SELECT 
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    c.email AS customer_email
FROM orders o
INNER JOIN customer c ON o.customer_id = c.customer_id;.

/* Question 18:
-- 18. Show every order line with:
--  o order_id, customer full name,
--  o product_name, category_name,
--  o quantity, line_total.
--  o Use joins across orders, customers, order_items, products, categories.*/
SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.line_total
FROM orders_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN customer c ON o.customer_id = c.customer_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id;

-- Question 19:
-- 19. Find all customers who have never placed any order.
--  o Use a left join from customers to orders.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.registration_date
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Question 20:
-- 20. Find all products that have never been sold (no rows in order_items referencing them).
--  o Use a left join from products to order_items.
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.stock_quantity
FROM products p
LEFT JOIN orders_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Question 21:
-- 21. For each product that has been sold at least once, show:
--  o product_name, category_name,
--  o total_quantity_sold,
--  o total_revenue (sum of line_total).
--  o Use joins and aggregation.
SELECT 
    p.product_name,
    cat.category_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.line_total) AS total_revenue
FROM orders_items oi
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, cat.category_name;

-- 22. For each supplier, show:
--  o supplier_name,
--  o number of purchase_orders they supplied,
--  o total_cost of all their purchase_orders.
--  o Use joins between suppliers and purchase_orders.
SELECT 
    s.supplier_name,
    COUNT(po.purchase_id) AS number_of_purchase_orders,
    COALESCE(SUM(po.total_cost), 0.00) AS total_cost
FROM suppliers s
LEFT JOIN purchase_orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name;

/* Aggregates & Grouping (23-26)
 Question 23:
-- 23. Find the top 5 customers by total amount spent (consider only non-cancelled orders).
--  o Show customer_name and total_spent.*/

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM customer c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status <> 'CANCELLED'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

/* Question 24:
 24. Compute monthly sales revenue for each month in 2026 using orders:
  o Group by year-month based on order_date,
  o show month, total_orders, total_revenue.*/

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS sale_month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE order_status <> 'CANCELLED'
  AND YEAR(order_date) = 2026
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sale_month ASC;

 /*25. List all products where the total quantity sold (sum across order_items) is greater than 5 units.
  o Show product_name and total_quantity_sold.*/
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
INNER JOIN orders_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) < 5
ORDER BY total_quantity_sold DESC;

/* 26. For each order_status (except CANCELLED), calculate:
  o number of orders,
  o total revenue,
  o average order value.*/
SELECT 
    order_status,
    COUNT(order_id) AS number_of_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_value
FROM orders
WHERE order_status <> 'CANCELLED'
GROUP BY order_status;

/* Subqueries on This Project (27-32)
27. Find products whose price is higher than the average price of all products in the system.
  o Use a scalar subquery in the WHERE clause.*/
  
SELECT 
    product_id,
    product_name,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

/* 28. Find orders whose total_amount is higher than the overall average total_amount of all orders
(exclude cancelled if you want).
--  o Use a subquery on orders.*/
SELECT 
    order_id,
    customer_id,
    order_date,
    order_status,
    total_amount
FROM orders
WHERE order_status <> 'CANCELLED'
  AND total_amount > (
      SELECT AVG(total_amount) 
      FROM orders 
      WHERE order_status <> 'CANCELLED'
  );
  
 /* 29. List customers who have bought at least one product from the "Electronics" category.
--  o Use IN or EXISTS with subqueries involving orders, order_items, products, and categories.*/
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    INNER JOIN orders_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    INNER JOIN categories cat ON p.category_id = cat.category_id
    WHERE o.customer_id = c.customer_id
      AND o.order_status <> 'CANCELLED'
      AND cat.category_name = 'Electronics'
);

/*30. Find products that have at least one purchase_item (stock purchased) but no sales in
-- order_items.
--  o Use NOT IN, NOT EXISTS, or a left join with NULL.*/
SELECT 
    p.product_id,
    p.product_name,
    p.stock_quantity
FROM products p
WHERE EXISTS (
    SELECT 1 
    FROM purchase_items pi 
    WHERE pi.product_id = p.product_id
)
AND NOT EXISTS (
    SELECT 1 
    FROM orders_items oi 
    WHERE oi.product_id = p.product_id
);

/*31. For each customer, show:
--  o customer_id, customer_name, total_spent,
--  o a computed column is_high_spender which is 'YES' if their total_spent is greater than the
--    average total_spent of all customers, otherwise 'NO'.
--  o Use a correlated or two-step subquery. HARDER */


SELECT 
    cust_totals.customer_id,
    cust_totals.customer_name,
    cust_totals.total_spent,
    CASE 
        WHEN cust_totals.total_spent > (
            SELECT AVG(sub.total_spent)
            FROM (
                SELECT c2.customer_id, COALESCE(SUM(o2.total_amount), 0) AS total_spent
                FROM customer c2
                LEFT JOIN orders o2 ON c2.customer_id = o2.customer_id AND o2.order_status <> 'CANCELLED'
                GROUP BY c2.customer_id
            ) sub
        ) THEN 'YES'
        ELSE 'NO'
    END AS is_high_spender
FROM (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COALESCE(SUM(o.total_amount), 0.00) AS total_spent
    FROM customer c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status <> 'CANCELLED'
    GROUP BY c.customer_id, c.first_name, c.last_name
) cust_totals;

/*32. Find the customer with the second highest total spending (non-cancelled orders only).
--  o Use a subquery that ranks totals or uses LIMIT/OFFSET style logic (depending on your
--    SQL dialect).*/
SELECT 
    customer_id,
    customer_name,
    total_spent
FROM (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(o.total_amount) AS total_spent,
        DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_rank
    FROM customer c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status <> 'CANCELLED'
    GROUP BY c.customer_id, c.first_name, c.last_name
) ranked_customers
WHERE spend_rank = 2;

/* Views in This Project (33-36)
 33. Using v_order_summary, list all orders placed in March 2026, showing order_id, order_date,
-- customer_name, total_amount, and order_status.*/
SELECT 
    order_id,
    order_date,
    customer_name,
    total_amount,
    order_status
FROM v_order_summary
WHERE order_date >= '2026-03-01 00:00:00'
  AND order_date <  '2026-04-01 00:00:00';
  
/*34. Using v_product_inventory, find products where total_sold is greater than total_purchased,
-- which suggests a stock calculation problem.*/
SELECT 
    product_id,
    product_name,
    category_name,
    stock_quantity,
    total_purchased,
    total_sold,
    calculated_stock
FROM v_product_inventory
WHERE total_sold > total_purchased;


/* Question 35:
-- 35. Using v_daily_sales, compute the total revenue for the last 7 days (relative to today or to the
-- latest order_date in your dataset).*/
SELECT 
    COALESCE(SUM(daily_revenue), 0.00) AS last_7_days_revenue
FROM v_daily_sales
WHERE sale_date >= (SELECT MAX(sale_date) - INTERVAL 6 DAY FROM v_daily_sales);


/*36. Using v_customer_summary, list customers who:
--  o have placed at least one order before, and
--  o have not placed any order in the last 30 days (based on last_order_date).*/

SELECT 
    customer_id,
    customer_name,
    city,
    total_orders,
    total_spent,
    last_order_date
FROM v_customer_summary
WHERE total_orders >= 1
  AND last_order_date < NOW() - INTERVAL 30 DAY;
  
  /* Stored Procedures & Logic (37-40)
   37. Call your PlaceOrder procedure to place an order for one customer and one product with a given
-- quantity.																								DOUBT
  o After calling, verify:
  - A row exists in orders,
  - A row exists in order_items,
  - stock_quantity for that product decreased correctly.*/
CALL PlaceOrder(1, 1, 2);

SELECT * FROM orders ORDER BY order_id DESC LIMIT 1;
SELECT * FROM order_items ORDER BY order_item_id DESC LIMIT 1;
SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;

 /*Real-World Challenges (41-50)
 41. Find customers who have purchased products from at least three different categories.
--  o Show customer_name and the number of distinct categories they purchased from; use
--    GROUP BY and HAVING with COUNT(DISTINCT category_id).*/
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT p.category_id) AS distinct_categories_purchased
FROM customer c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN orders_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status <> 'CANCELLED'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT p.category_id) >= 3;

/*42. Estimate profit per product assuming:
--  o Average purchase unit_cost comes from purchase_items,
--  o Sales unit_price comes from order_items.
--  o For each product, compute total revenue - total purchase cost.*/
SELECT 
    p.product_id,
    p.product_name,
    COALESCE(sales.total_qty_sold, 0) AS total_quantity_sold,
    COALESCE(sales.total_revenue, 0.00) AS total_revenue,
    COALESCE(purchases.avg_unit_cost, 0.00) AS avg_purchase_unit_cost,
    ROUND(COALESCE(sales.total_qty_sold, 0) * COALESCE(purchases.avg_unit_cost, 0.00), 2) AS estimated_cost_of_goods_sold,
    ROUND(COALESCE(sales.total_revenue, 0.00) - (COALESCE(sales.total_qty_sold, 0) * COALESCE(purchases.avg_unit_cost, 0.00)), 2) AS estimated_profit,
    ROUND(COALESCE(sales.total_revenue, 0.00) - COALESCE(purchases.total_purchase_cost, 0.00), 2) AS net_revenue_minus_all_purchases
FROM products p
LEFT JOIN (
    SELECT 
        product_id,
        SUM(quantity) AS total_qty_sold,
        SUM(line_total) AS total_revenue
    FROM orders_items
    GROUP BY product_id
) sales ON p.product_id = sales.product_id
LEFT JOIN (
    SELECT 
        product_id,
        AVG(unit_cost) AS avg_unit_cost,
        SUM(line_cost) AS total_purchase_cost
    FROM purchase_items
    GROUP BY product_id
) purchases ON p.product_id = purchases.product_id;

/*43. For each category, find the single most sold product (by total_quantity_sold).
--  o Show category_name, product_name, total_quantity_sold.
--  o Use either window functions (if available) or a nested subquery.*/

SELECT 
    category_name,
    product_name,
    total_quantity_sold
FROM (
    SELECT 
        cat.category_name,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY cat.category_id 
            ORDER BY SUM(oi.quantity) DESC
        ) AS rn
    FROM categories cat
    INNER JOIN products p ON cat.category_id = p.category_id
    INNER JOIN orders_items oi ON p.product_id = oi.product_id
    GROUP BY cat.category_id, cat.category_name, p.product_id, p.product_name
) ranked_products
WHERE rn = 1;

/*44. List orders where the customer placed the order within 7 days after their registration_date.
--  o Show customer_name, order_id, registration_date, order_date, and the day difference.*/
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    c.registration_date,
    o.order_date,
    DATEDIFF(o.order_date, c.registration_date) AS day_difference
FROM orders o
INNER JOIN customer c ON o.customer_id = c.customer_id
WHERE o.order_date >= c.registration_date
  AND DATEDIFF(o.order_date, c.registration_date) <= 7;
  
 /* 45. Design and query a view (or a SELECT) that shows low stock alerts, including:
--  o product_name, category_name, stock_quantity,
--  o a recommended_restock amount (for example, to reach 50 units).*/

CREATE OR REPLACE VIEW v_low_stock_alerts AS
SELECT 
    p.product_name,
    cat.category_name,
    p.stock_quantity,
    (50 - p.stock_quantity) AS recommended_restock
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
WHERE p.stock_quantity < 50;

SELECT * FROM v_low_stock_alerts ORDER BY stock_quantity ASC;

/*46. Find suppliers who supplied products that together generated more than a certain sales
-- revenue (e.g., 100,000) in order_items.
--  o Link suppliers -> purchase_orders -> purchase_items -> products -> order_items.*/
SELECT 
    s.supplier_id,
    s.supplier_name,
    SUM(oi.line_total) AS total_generated_sales_revenue
FROM suppliers s
INNER JOIN (
    -- Distinct supplier-product pairs so multiple purchase orders don't duplicate sales rows
    SELECT DISTINCT po.supplier_id, pi.product_id
    FROM purchase_orders po
    INNER JOIN purchase_items pi ON po.purchase_id = pi.purchase_id
) sp ON s.supplier_id = sp.supplier_id
INNER JOIN products p ON sp.product_id = p.product_id
INNER JOIN orders_items oi ON p.product_id = oi.product_id
GROUP BY s.supplier_id, s.supplier_name
HAVING SUM(oi.line_total) > 100000.00;

/*47. For March 2026, produce a running total of daily revenue using v_daily_sales or directly from
-- orders, ordered by sale_date.
--  o Show sale_date, daily_revenue, running_total.*/

SELECT 
    sale_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY sale_date ASC) AS running_total
FROM v_daily_sales
WHERE sale_date >= '2026-03-01'
  AND sale_date <= '2026-03-31'
ORDER BY sale_date ASC;

/*48. Find pairs of products that were bought together in the same order (e.g., "iPhone +
-- Headphones").
--  o Use a self-join on order_items on the same order_id but different product_id.*/

SELECT 
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(DISTINCT oi1.order_id) AS times_bought_together
FROM orders_items oi1
INNER JOIN orders_items oi2 
    ON oi1.order_id = oi2.order_id 
    AND oi1.product_id < oi2.product_id
INNER JOIN products p1 ON oi1.product_id = p1.product_id
INNER JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY p1.product_id, p1.product_name, p2.product_id, p2.product_name
ORDER BY times_bought_together DESC;

/*49. Recalculate each order's total_amount from its order_items (sum of line_total) and update the orders
-- table accordingly.
--  o Use an UPDATE with a subquery or a join.*/

UPDATE orders o
LEFT JOIN (
    SELECT 
        order_id, 
        SUM(line_total) AS calculated_total
    FROM orders_items
    GROUP BY order_id
) item_totals ON o.order_id = item_totals.order_id
SET o.total_amount = COALESCE(item_totals.calculated_total, 0.00);

/*50. Test your cascading delete design by deleting one customer and then checking:
--  o Are their orders removed?
--  o Are their order_items removed?
--  o Are other customers and their orders untouched?*/

-- Step 1: Delete customer with customer_id = 1
DELETE FROM customer
WHERE customer_id = 1;

-- Step 2: Check if their orders are removed (Expected: 0 rows)
SELECT * FROM orders
WHERE customer_id = 1;

-- Step 3: Check if their order_items are removed (Expected: 0 rows)
SELECT oi.*
FROM orders_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.customer_id = 1 OR o.order_id IS NULL;

-- Step 4: Verify other customers and their orders are untouched
SELECT COUNT(*) AS remaining_customers FROM customer;
SELECT COUNT(*) AS remaining_orders FROM orders;