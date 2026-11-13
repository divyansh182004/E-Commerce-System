# E-Commerce-System

Welcome to the E-Commerce SQL Project repository! This project provides a comprehensive database schema design, analytical views, and an extensive problem-solving practice suite designed to build and test core relational database management skills—spanning DDL, DML, complex joins, subqueries, analytical views, stored procedures, and real-world data challenges.

🏗️ Project Scope & Architecture
The system models a functional medium-level e-commerce business operations environment, tracking customers, product inventories, categories, suppliers, sales orders, purchase orders, and item line details.   
Base Tables: 8 core relational tables enforcing strict primary keys, foreign key cascading/restriction rules, unique constraints, and check conditions.   
Analytical Views: 4 virtual aggregation-based reporting views for tracking orders, inventories, daily revenues, and customer metrics.   
Practice Suite: 50 targeted SQL tasks spanning 8 operational categories.

🗄️ Database Schema Overview1. Base Tablescustomers: 
Stores buyer profiles, unique emails, cities, and registration stamps.   
categories: Organizes products into logical groups with unique category titles.   
products: Item catalog featuring stock quantities, active flags, and prices protected by positive check constraints (> 0).   
suppliers: Vendor directories managing external stock sources.   
orders: Transaction headers tracking status flows (PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED) and totals.   
order_items: Line-item details capturing locked historical unit prices at the moment of sale.   

Analytical Views (CREATE VIEW)
v_order_summary: Aggregates order metrics, customer profile details, item counts, and aggregate quantities per transaction.   
v_product_inventory: Tracks stock discrepancies by contrasting lifetime units purchased against units sold.   v_daily_sales: Computes day-level revenue breakdowns, active order volumes, and average order values.   v_customer_summary: Provides lifetime analytics per customer including total spending, order counts, and last purchase activity dates.   
purchase_orders: Incoming vendor stock acquisition headers.   
purchase_items: Individual line costs and quantities associated with supplier purchases

🧭 Practice Question ModulesThe project schema is designed to test advanced SQL capabilities through 50 practical tasks divided into the following categories:A. 
A. DDL & Schema (Questions 1–8): 
Modifying columns, configuring check constraints, implementing indexes, adding new transactional tables (e.g., product_reviews), and evaluating strict foreign key cascading rules.   
B. DML Operations (Questions 9–16): Bulk updating categories, handling multi-item order checkouts, automated status changes (e.g., closing stale PENDING orders), inventory adjustments, and cleanup routines.   
C. Joins & Relationships (Questions 17–22): Extracting multi-table entity details, identifying inactive users or un-sold stock via left joins, and aggregating product revenues and supplier metrics.   
D. Aggregates & Grouping (Questions 23–26): Discovering top spenders, computing monthly recurring revenues for 2026, and analyzing filtered order statuses.   
E. Subqueries (Questions 27–32): Utilizing scalar subqueries, identifying high spenders relative to overall systems averages, and using IN/EXISTS operators.   
F. Views Usage (Questions 33–36): Querying historical date ranges, surfacing stock discrepancies, and tracking dormant customer segments via the reporting views.   
G. Stored Procedures & Logic (Questions 37–40): Simulating automated checkout procedures (PlaceOrder), validating inventory checks, raising stock errors, and running batch inventory restocks.   
H. Harder Real-World Challenges (Questions 41–50): Multi-category customer profiling, product-level profit estimations, running totals, market basket analysis via self-joins, and transaction validation tests
