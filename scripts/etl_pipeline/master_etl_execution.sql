-- =============================================
-- Master ETL Execution Script for MySQL Data Warehouse
-- Description: Complete ETL pipeline execution from Bronze to Gold
-- Run this script after setting up the database structure
-- =============================================

USE data_warehouse;

-- =============================================
-- STEP 1: VERIFY DATABASE STRUCTURE
-- =============================================

SELECT 'Starting ETL Pipeline Execution...' as status;

-- Check if all required tables exist
SELECT 
    table_name,
    table_rows,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS size_mb
FROM information_schema.tables 
WHERE table_schema = 'data_warehouse' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- =============================================
-- STEP 2: EXECUTE BRONZE LAYER ETL
-- =============================================

SELECT 'Executing Bronze Layer ETL...' as status;

-- Execute Bronze layer data load
CALL load_bronze_layer();

SELECT 'Bronze Layer ETL Completed' as status;

-- =============================================
-- STEP 3: EXECUTE SILVER LAYER ETL
-- =============================================

SELECT 'Executing Silver Layer ETL...' as status;

-- Execute Silver layer data load
CALL load_silver_layer();

SELECT 'Silver Layer ETL Completed' as status;

-- =============================================
-- STEP 4: VERIFY GOLD LAYER VIEWS
-- =============================================

SELECT 'Verifying Gold Layer Views...' as status;

-- Check Gold layer view record counts
SELECT 'gold_customer_summary' as view_name, COUNT(*) as record_count FROM gold_customer_summary
UNION ALL
SELECT 'gold_product_performance' as view_name, COUNT(*) as record_count FROM gold_product_performance
UNION ALL
SELECT 'gold_monthly_sales' as view_name, COUNT(*) as record_count FROM gold_monthly_sales
UNION ALL
SELECT 'gold_daily_sales_trend' as view_name, COUNT(*) as record_count FROM gold_daily_sales_trend
UNION ALL
SELECT 'gold_top_customers' as view_name, COUNT(*) as record_count FROM gold_top_customers
UNION ALL
SELECT 'gold_business_kpis' as view_name, COUNT(*) as record_count FROM gold_business_kpis
UNION ALL
SELECT 'gold_regional_performance' as view_name, COUNT(*) as record_count FROM gold_regional_performance;

-- =============================================
-- STEP 5: EXECUTE DATA QUALITY CHECKS
-- =============================================

SELECT 'Running Data Quality Checks...' as status;

-- Run comprehensive data quality checks
-- (Data quality check queries would go here - referencing the data_quality_checks.sql file)

-- Quick validation: Check for any null keys in Silver layer
SELECT 'Data Quality - Null Keys Check' as check_name;

SELECT 
    'silver_customer_master' as table_name,
    COUNT(*) as null_key_count
FROM silver_customer_master 
WHERE customer_key IS NULL OR customer_key = ''

UNION ALL

SELECT 
    'silver_product_master' as table_name,
    COUNT(*) as null_key_count
FROM silver_product_master 
WHERE product_key IS NULL OR product_key = ''

UNION ALL

SELECT 
    'silver_sales_fact' as table_name,
    COUNT(*) as null_key_count
FROM silver_sales_fact 
WHERE customer_key IS NULL OR customer_key = '' 
   OR product_key IS NULL OR product_key = '';

-- =============================================
-- STEP 6: GENERATE SUMMARY REPORT
-- =============================================

SELECT 'Generating ETL Summary Report...' as status;

-- ETL Summary Report
SELECT 'ETL EXECUTION SUMMARY REPORT' as report_title;

-- Record counts by layer
SELECT 
    'Bronze Layer Total' as layer,
    (SELECT COUNT(*) FROM bronze_crm_customer_info) +
    (SELECT COUNT(*) FROM bronze_crm_product_info) +
    (SELECT COUNT(*) FROM bronze_crm_sales_details) +
    (SELECT COUNT(*) FROM bronze_erp_customer_info) +
    (SELECT COUNT(*) FROM bronze_erp_product_info) +
    (SELECT COUNT(*) FROM bronze_erp_sales_details) as total_records

UNION ALL

SELECT 
    'Silver Layer Total' as layer,
    (SELECT COUNT(*) FROM silver_customer_master) +
    (SELECT COUNT(*) FROM silver_product_master) +
    (SELECT COUNT(*) FROM silver_sales_fact) as total_records

UNION ALL

SELECT 
    'Gold Layer Views' as layer,
    8 as total_records;  -- Number of Gold layer views

-- Business metrics summary
SELECT 'BUSINESS METRICS SUMMARY' as metrics_title;

SELECT * FROM gold_business_kpis;

-- Top 5 customers by revenue
SELECT 'TOP 5 CUSTOMERS BY REVENUE' as top_customers_title;

SELECT 
    customer_name,
    customer_city,
    customer_state,
    total_sales_amount,
    total_orders,
    avg_order_value
FROM gold_top_customers 
LIMIT 5;

-- Top 5 products by revenue
SELECT 'TOP 5 PRODUCTS BY REVENUE' as top_products_title;

SELECT 
    product_name,
    product_category,
    total_revenue,
    total_quantity_sold
FROM gold_product_performance 
ORDER BY total_revenue DESC 
LIMIT 5;

-- Monthly sales trend (last 6 months)
SELECT 'MONTHLY SALES TREND (LAST 6 MONTHS)' as sales_trend_title;

SELECT 
    CONCAT(sales_year, '-', LPAD(sales_month, 2, '0')) as year_month,
    month_name,
    total_sales_amount,
    total_orders,
    unique_customers
FROM gold_monthly_sales 
ORDER BY sales_year DESC, sales_month DESC 
LIMIT 6;

-- =============================================
-- STEP 7: ETL COMPLETION
-- =============================================

SELECT 
    'ETL Pipeline Completed Successfully!' as status,
    NOW() as completion_time;

-- Performance metrics
SELECT 
    'ETL Performance Metrics' as metric_type,
    CONCAT('Execution completed at ', NOW()) as metric_value

UNION ALL

SELECT 
    'Total Data Processed' as metric_type,
    CONCAT((SELECT SUM(table_rows) FROM information_schema.tables 
            WHERE table_schema = 'data_warehouse' AND table_type = 'BASE TABLE'), ' records') as metric_value;

SELECT 'Ready for Analytics and Reporting!' as final_status;
