-- =============================================
-- Silver Layer Data Load Procedure for MySQL
-- Description: Loads and transforms data from Bronze to Silver layer
-- Converted from SQL Server to MySQL
-- =============================================

USE data_warehouse;

DELIMITER //

DROP PROCEDURE IF EXISTS load_silver_layer //
CREATE PROCEDURE load_silver_layer()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    
    -- Clear existing Silver layer data
    DELETE FROM silver_sales_fact;
    DELETE FROM silver_product_master;
    DELETE FROM silver_customer_master;
    
    -- =============================================
    -- Load Customer Master (Consolidate CRM and ERP)
    -- =============================================
    
    INSERT INTO silver_customer_master 
    (customer_key, customer_name, customer_email, customer_phone, 
     customer_address, customer_city, customer_state, customer_country, 
     customer_zipcode, source_system, created_date)
    SELECT DISTINCT
        customer_key,
        TRIM(customer_name) as customer_name,
        CASE 
            WHEN customer_email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' 
            THEN LOWER(TRIM(customer_email))
            ELSE NULL 
        END as customer_email,
        CASE 
            WHEN LENGTH(TRIM(customer_phone)) >= 10 
            THEN TRIM(customer_phone)
            ELSE NULL 
        END as customer_phone,
        TRIM(customer_address) as customer_address,
        TRIM(customer_city) as customer_city,
        TRIM(customer_state) as customer_state,
        TRIM(customer_country) as customer_country,
        TRIM(customer_zipcode) as customer_zipcode,
        'CRM' as source_system,
        NOW() as created_date
    FROM bronze_crm_customer_info
    WHERE customer_key IS NOT NULL 
      AND TRIM(customer_name) != ''
    
    UNION
    
    SELECT DISTINCT
        customer_key,
        TRIM(customer_name) as customer_name,
        CASE 
            WHEN customer_email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' 
            THEN LOWER(TRIM(customer_email))
            ELSE NULL 
        END as customer_email,
        CASE 
            WHEN LENGTH(TRIM(customer_phone)) >= 10 
            THEN TRIM(customer_phone)
            ELSE NULL 
        END as customer_phone,
        TRIM(customer_address) as customer_address,
        TRIM(customer_city) as customer_city,
        TRIM(customer_state) as customer_state,
        TRIM(customer_country) as customer_country,
        TRIM(customer_zipcode) as customer_zipcode,
        'ERP' as source_system,
        NOW() as created_date
    FROM bronze_erp_customer_info
    WHERE customer_key IS NOT NULL 
      AND TRIM(customer_name) != ''
      AND customer_key NOT IN (
          SELECT customer_key 
          FROM bronze_crm_customer_info 
          WHERE customer_key IS NOT NULL
      );
    
    -- =============================================
    -- Load Product Master (Consolidate CRM and ERP)
    -- =============================================
    
    INSERT INTO silver_product_master 
    (product_key, product_name, product_category, product_subcategory,
     product_brand, product_price, product_cost, source_system, created_date)
    SELECT DISTINCT
        product_key,
        TRIM(product_name) as product_name,
        TRIM(product_category) as product_category,
        TRIM(product_subcategory) as product_subcategory,
        TRIM(product_brand) as product_brand,
        CASE 
            WHEN product_price >= 0 THEN product_price 
            ELSE 0 
        END as product_price,
        CASE 
            WHEN product_cost >= 0 THEN product_cost 
            ELSE 0 
        END as product_cost,
        'CRM' as source_system,
        NOW() as created_date
    FROM bronze_crm_product_info
    WHERE product_key IS NOT NULL 
      AND TRIM(product_name) != ''
    
    UNION
    
    SELECT DISTINCT
        product_key,
        TRIM(product_name) as product_name,
        TRIM(product_category) as product_category,
        TRIM(product_subcategory) as product_subcategory,
        TRIM(product_brand) as product_brand,
        CASE 
            WHEN product_price >= 0 THEN product_price 
            ELSE 0 
        END as product_price,
        CASE 
            WHEN product_cost >= 0 THEN product_cost 
            ELSE 0 
        END as product_cost,
        'ERP' as source_system,
        NOW() as created_date
    FROM bronze_erp_product_info
    WHERE product_key IS NOT NULL 
      AND TRIM(product_name) != ''
      AND product_key NOT IN (
          SELECT product_key 
          FROM bronze_crm_product_info 
          WHERE product_key IS NOT NULL
      );
    
    -- =============================================
    -- Load Sales Fact (Consolidate CRM and ERP)
    -- =============================================
    
    INSERT INTO silver_sales_fact 
    (order_id, customer_key, product_key, order_date, ship_date,
     quantity, unit_price, discount_amount, sales_amount, source_system, created_date)
    SELECT 
        order_id,
        customer_key,
        product_key,
        order_date,
        ship_date,
        CASE 
            WHEN quantity > 0 THEN quantity 
            ELSE 0 
        END as quantity,
        CASE 
            WHEN unit_price >= 0 THEN unit_price 
            ELSE 0 
        END as unit_price,
        CASE 
            WHEN discount_amount >= 0 THEN discount_amount 
            ELSE 0 
        END as discount_amount,
        CASE 
            WHEN sales_amount >= 0 THEN sales_amount 
            ELSE 0 
        END as sales_amount,
        'CRM' as source_system,
        NOW() as created_date
    FROM bronze_crm_sales_details
    WHERE order_id IS NOT NULL 
      AND customer_key IS NOT NULL 
      AND product_key IS NOT NULL
      AND order_date IS NOT NULL
      AND customer_key IN (SELECT customer_key FROM silver_customer_master)
      AND product_key IN (SELECT product_key FROM silver_product_master)
    
    UNION ALL
    
    SELECT 
        order_id,
        customer_key,
        product_key,
        order_date,
        ship_date,
        CASE 
            WHEN quantity > 0 THEN quantity 
            ELSE 0 
        END as quantity,
        CASE 
            WHEN unit_price >= 0 THEN unit_price 
            ELSE 0 
        END as unit_price,
        CASE 
            WHEN discount_amount >= 0 THEN discount_amount 
            ELSE 0 
        END as discount_amount,
        CASE 
            WHEN sales_amount >= 0 THEN sales_amount 
            ELSE 0 
        END as sales_amount,
        'ERP' as source_system,
        NOW() as created_date
    FROM bronze_erp_sales_details
    WHERE order_id IS NOT NULL 
      AND customer_key IS NOT NULL 
      AND product_key IS NOT NULL
      AND order_date IS NOT NULL
      AND customer_key IN (SELECT customer_key FROM silver_customer_master)
      AND product_key IN (SELECT product_key FROM silver_product_master);
    
    COMMIT;
    
    -- Return row counts for verification
    SELECT 
        'silver_customer_master' as table_name,
        COUNT(*) as row_count
    FROM silver_customer_master
    UNION ALL
    SELECT 
        'silver_product_master' as table_name,
        COUNT(*) as row_count
    FROM silver_product_master
    UNION ALL
    SELECT 
        'silver_sales_fact' as table_name,
        COUNT(*) as row_count
    FROM silver_sales_fact;
    
END //

DELIMITER ;

SELECT 'Silver layer load procedure created successfully!' as Status;
