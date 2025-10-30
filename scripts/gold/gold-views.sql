-- =============================================
-- Gold Layer Views for MySQL Data Warehouse
-- Description: Creates business-ready views for analytics and reporting
-- Converted from SQL Server to MySQL
-- =============================================

USE data_warehouse;

-- =============================================
-- CUSTOMER ANALYTICS VIEWS
-- =============================================

-- Customer Summary View
DROP VIEW IF EXISTS gold_customer_summary;
CREATE VIEW gold_customer_summary AS
SELECT 
    c.customer_key,
    c.customer_name,
    c.customer_city,
    c.customer_state,
    c.customer_country,
    c.source_system,
    COUNT(DISTINCT s.order_id) as total_orders,
    SUM(s.quantity) as total_quantity_purchased,
    SUM(s.sales_amount) as total_sales_amount,
    SUM(s.net_sales_amount) as total_net_sales_amount,
    AVG(s.sales_amount) as avg_order_value,
    MIN(s.order_date) as first_purchase_date,
    MAX(s.order_date) as last_purchase_date,
    DATEDIFF(MAX(s.order_date), MIN(s.order_date)) as customer_lifetime_days
FROM silver_customer_master c
LEFT JOIN silver_sales_fact s ON c.customer_key = s.customer_key
WHERE c.is_active = TRUE
GROUP BY c.customer_key, c.customer_name, c.customer_city, 
         c.customer_state, c.customer_country, c.source_system;

-- Top Customers by Revenue View
DROP VIEW IF EXISTS gold_top_customers;
CREATE VIEW gold_top_customers AS
SELECT 
    customer_key,
    customer_name,
    customer_city,
    customer_state,
    total_sales_amount,
    total_orders,
    avg_order_value,
    RANK() OVER (ORDER BY total_sales_amount DESC) as revenue_rank
FROM gold_customer_summary
WHERE total_sales_amount > 0
ORDER BY total_sales_amount DESC;

-- =============================================
-- PRODUCT ANALYTICS VIEWS
-- =============================================

-- Product Performance View
DROP VIEW IF EXISTS gold_product_performance;
CREATE VIEW gold_product_performance AS
SELECT 
    p.product_key,
    p.product_name,
    p.product_category,
    p.product_subcategory,
    p.product_brand,
    p.product_price,
    p.product_cost,
    p.profit_margin,
    p.source_system,
    COUNT(DISTINCT s.order_id) as total_orders,
    SUM(s.quantity) as total_quantity_sold,
    SUM(s.sales_amount) as total_revenue,
    SUM(s.net_sales_amount) as total_net_revenue,
    SUM(s.quantity * p.product_cost) as total_cost,
    SUM(s.net_sales_amount) - SUM(s.quantity * p.product_cost) as total_profit,
    AVG(s.unit_price) as avg_selling_price
FROM silver_product_master p
LEFT JOIN silver_sales_fact s ON p.product_key = s.product_key
WHERE p.is_active = TRUE
GROUP BY p.product_key, p.product_name, p.product_category, 
         p.product_subcategory, p.product_brand, p.product_price,
         p.product_cost, p.profit_margin, p.source_system;

-- Top Products by Category View
DROP VIEW IF EXISTS gold_top_products_by_category;
CREATE VIEW gold_top_products_by_category AS
SELECT 
    product_category,
    product_key,
    product_name,
    total_revenue,
    total_quantity_sold,
    ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY total_revenue DESC) as category_rank
FROM gold_product_performance
WHERE total_revenue > 0;

-- =============================================
-- SALES ANALYTICS VIEWS
-- =============================================

-- Monthly Sales Summary View
DROP VIEW IF EXISTS gold_monthly_sales;
CREATE VIEW gold_monthly_sales AS
SELECT 
    YEAR(s.order_date) as sales_year,
    MONTH(s.order_date) as sales_month,
    MONTHNAME(s.order_date) as month_name,
    s.source_system,
    COUNT(DISTINCT s.order_id) as total_orders,
    COUNT(DISTINCT s.customer_key) as unique_customers,
    COUNT(DISTINCT s.product_key) as unique_products,
    SUM(s.quantity) as total_quantity,
    SUM(s.sales_amount) as total_sales_amount,
    SUM(s.discount_amount) as total_discount_amount,
    SUM(s.net_sales_amount) as total_net_sales_amount,
    AVG(s.sales_amount) as avg_order_value
FROM silver_sales_fact s
GROUP BY YEAR(s.order_date), MONTH(s.order_date), 
         MONTHNAME(s.order_date), s.source_system
ORDER BY sales_year DESC, sales_month DESC;

-- Daily Sales Trend View
DROP VIEW IF EXISTS gold_daily_sales_trend;
CREATE VIEW gold_daily_sales_trend AS
SELECT 
    s.order_date,
    DAYNAME(s.order_date) as day_name,
    WEEKDAY(s.order_date) + 1 as day_of_week,
    s.source_system,
    COUNT(DISTINCT s.order_id) as daily_orders,
    SUM(s.sales_amount) as daily_sales_amount,
    SUM(s.net_sales_amount) as daily_net_sales_amount,
    AVG(s.sales_amount) as avg_daily_order_value
FROM silver_sales_fact s
GROUP BY s.order_date, DAYNAME(s.order_date), 
         WEEKDAY(s.order_date), s.source_system
ORDER BY s.order_date DESC;

-- =============================================
-- KPI DASHBOARD VIEW
-- =============================================

-- Business KPI Summary View
DROP VIEW IF EXISTS gold_business_kpis;
CREATE VIEW gold_business_kpis AS
SELECT 
    -- Current Period Metrics
    COUNT(DISTINCT customer_key) as total_customers,
    COUNT(DISTINCT product_key) as total_products,
    COUNT(DISTINCT order_id) as total_orders,
    SUM(sales_amount) as total_revenue,
    SUM(net_sales_amount) as total_net_revenue,
    SUM(discount_amount) as total_discounts,
    AVG(sales_amount) as avg_order_value,
    
    -- Date Range
    MIN(order_date) as data_start_date,
    MAX(order_date) as data_end_date,
    
    -- Source System Breakdown
    SUM(CASE WHEN source_system = 'CRM' THEN sales_amount ELSE 0 END) as crm_revenue,
    SUM(CASE WHEN source_system = 'ERP' THEN sales_amount ELSE 0 END) as erp_revenue,
    
    -- Performance Metrics
    COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_key) as orders_per_customer,
    SUM(quantity) / COUNT(DISTINCT order_id) as avg_items_per_order
FROM silver_sales_fact;

-- Regional Sales Performance View
DROP VIEW IF EXISTS gold_regional_performance;
CREATE VIEW gold_regional_performance AS
SELECT 
    c.customer_country,
    c.customer_state,
    c.customer_city,
    COUNT(DISTINCT s.customer_key) as unique_customers,
    COUNT(DISTINCT s.order_id) as total_orders,
    SUM(s.sales_amount) as total_revenue,
    SUM(s.net_sales_amount) as total_net_revenue,
    AVG(s.sales_amount) as avg_order_value,
    RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) as revenue_rank
FROM silver_customer_master c
INNER JOIN silver_sales_fact s ON c.customer_key = s.customer_key
WHERE c.is_active = TRUE
GROUP BY c.customer_country, c.customer_state, c.customer_city
HAVING total_revenue > 0
ORDER BY total_revenue DESC;

SELECT 'Gold layer views created successfully!' as Status;
