use project;
CREATE VIEW v_order_summary AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.city,
    COUNT(oi.order_item_id) AS items_count,
    SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN customer c
    ON o.customer_id = c.customer_id
JOIN orders_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city;
SELECT * FROM v_order_summary;


/* 2ND VIEW */

CREATE VIEW v_product_inventory AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.stock_quantity,

    COALESCE(pur.total_purchased, 0) AS total_purchased,
    COALESCE(sol.total_sold, 0) AS total_sold,

    p.stock_quantity
        + COALESCE(sol.total_sold, 0)
        - COALESCE(pur.total_purchased, 0) AS calculated_stock

FROM products p

JOIN categories c
    ON p.category_id = c.category_id

LEFT JOIN (
    SELECT
        product_id,
        SUM(quantity) AS total_purchased
    FROM purchase_items
    GROUP BY product_id
) pur
    ON p.product_id = pur.product_id

LEFT JOIN (
    SELECT
        product_id,
        SUM(quantity) AS total_sold
    FROM orders_items
    GROUP BY product_id
) sol
    ON p.product_id = sol.product_id;
    SELECT * FROM v_product_inventory;
    
    /* 3RD VIEW */
    
    create view v_daily_sales as
    select 
    DATE(o.order_date) as sale_date,
    count(distinct o.order_id) as total_orders,
    sum( o.total_amount) as daily_revenue,
    avg( o.total_amount) as avg_order_value
    from orders o 
    where o.order_status <> "CANCELLED"
    group by date (o.order_date);
    select  * from v_daily_sales;
    
    /*  4TH VIEW */
    
    create view v_customer_summary as 
    select
    c.customer_id,
    concat(c.first_name,' ',c.last_name) as customer_name,
    c.city,
    c.registration_date,
    count(o.order_id) as total_orders,
    
    coalesce(sum(o.total_amount),0) as total_spent,
    coalesce(avg(o.total_amount),0) as avg_order_value,
    max(o.order_date) as last_order_date
    from customer c
    
    left join orders o
    on c.customer_id = o.customer_id
    and order_status <> "CANCELLED"
    GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.registration_date;
    select * from v_customer_summary;