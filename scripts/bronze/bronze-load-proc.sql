-- =============================================
-- Bronze Layer Data Load Procedure for MySQL
-- Description: Loads data from CSV files into Bronze layer tables
-- Converted from SQL Server to MySQL
-- =============================================

USE data_warehouse;

DELIMITER //

DROP PROCEDURE IF EXISTS load_bronze_layer //
CREATE PROCEDURE load_bronze_layer()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    
    -- Clear existing data (Full Load approach)
    DELETE FROM bronze_crm_customer_info;
    DELETE FROM bronze_crm_product_info;
    DELETE FROM bronze_crm_sales_details;
    DELETE FROM bronze_erp_customer_info;
    DELETE FROM bronze_erp_product_info;
    DELETE FROM bronze_erp_sales_details;
    
    -- Note: In MySQL, you need to enable local_infile and place CSV files in secure_file_priv directory
    -- or use MySQL Workbench's Table Data Import Wizard
    
    -- Load CRM Customer Info
    -- Replace '/path/to/datasets/' with your actual CSV file path
    LOAD DATA INFILE '/path/to/datasets/crm/customer_info.csv'
    INTO TABLE bronze_crm_customer_info
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (ID, customer_key, customer_name, customer_email, customer_phone, 
     customer_address, customer_city, customer_state, customer_country, 
     customer_zipcode, @created_date)
    SET created_date = NOW();
    
    -- Load CRM Product Info
    LOAD DATA INFILE '/path/to/datasets/crm/product_info.csv'
    INTO TABLE bronze_crm_product_info
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (ID, product_key, product_name, product_category, product_subcategory,
     product_brand, product_price, product_cost, @created_date)
    SET created_date = NOW();
    
    -- Load CRM Sales Details
    LOAD DATA INFILE '/path/to/datasets/crm/sales_details.csv'
    INTO TABLE bronze_crm_sales_details
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (ID, order_id, customer_key, product_key, @order_date, @ship_date,
     quantity, unit_price, discount_amount, sales_amount, @created_date)
    SET order_date = STR_TO_DATE(@order_date, '%Y-%m-%d'),
        ship_date = STR_TO_DATE(@ship_date, '%Y-%m-%d'),
        created_date = NOW();
    
    -- Load ERP Customer Info
    LOAD DATA INFILE '/path/to/datasets/erp/customer_info.csv'
    INTO TABLE bronze_erp_customer_info
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (ID, customer_key, customer_name, customer_email, customer_phone,
     customer_address, customer_city, customer_state, customer_country,
     customer_zipcode, @created_date)
    SET created_date = NOW();
    
    -- Load ERP Product Info
    LOAD DATA INFILE '/path/to/datasets/erp/product_info.csv'
    INTO TABLE bronze_erp_product_info
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (ID, product_key, product_name, product_category, product_subcategory,
     product_brand, product_price, product_cost, @created_date)
    SET created_date = NOW();
    
    -- Load ERP Sales Details
    LOAD DATA INFILE '/path/to/datasets/erp/sales_details.csv'
    INTO TABLE bronze_erp_sales_details
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (ID, order_id, customer_key, product_key, @order_date, @ship_date,
     quantity, unit_price, discount_amount, sales_amount, @created_date)
    SET order_date = STR_TO_DATE(@order_date, '%Y-%m-%d'),
        ship_date = STR_TO_DATE(@ship_date, '%Y-%m-%d'),
        created_date = NOW();
    
    COMMIT;
    
    -- Return row counts for verification
    SELECT 
        'bronze_crm_customer_info' as table_name,
        COUNT(*) as row_count
    FROM bronze_crm_customer_info
    UNION ALL
    SELECT 
        'bronze_crm_product_info' as table_name,
        COUNT(*) as row_count
    FROM bronze_crm_product_info
    UNION ALL
    SELECT 
        'bronze_crm_sales_details' as table_name,
        COUNT(*) as row_count
    FROM bronze_crm_sales_details
    UNION ALL
    SELECT 
        'bronze_erp_customer_info' as table_name,
        COUNT(*) as row_count
    FROM bronze_erp_customer_info
    UNION ALL
    SELECT 
        'bronze_erp_product_info' as table_name,
        COUNT(*) as row_count
    FROM bronze_erp_product_info
    UNION ALL
    SELECT 
        'bronze_erp_sales_details' as table_name,
        COUNT(*) as row_count
    FROM bronze_erp_sales_details;
    
END //

DELIMITER ;

-- Alternative method using MySQL Workbench Table Data Import Wizard:
-- 1. Right-click on table name
-- 2. Select "Table Data Import Wizard"
-- 3. Browse to CSV file
-- 4. Configure column mappings
-- 5. Execute import

SELECT 'Bronze layer load procedure created successfully!' as Status;
