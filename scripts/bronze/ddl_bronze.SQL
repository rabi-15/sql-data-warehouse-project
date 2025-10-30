/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
-- ----------------------------------------------------------
-- Ensure you are targeting the correct database 
-- ----------------------------------------------------------
USE DataWarehouse_Bronze;

-- ----------------------------------------------------------
-- CRM customer Information (bronze_crm_cust_info)
-- ----------------------------------------------------------
CREATE TABLE bronze_crm_cust_info (
    cst_id                 INT,
    cst_key                VARCHAR(50), -- Changed from NVARCHAR
    cst_firstname          VARCHAR(50), -- Changed from NVARCHAR
    cst_lastname           VARCHAR(50), -- Changed from NVARCHAR
    cst_marital_status     VARCHAR(50), -- Changed from NVARCHAR
    cst_gndr               VARCHAR(50), -- Changed from NVARCHAR
    cst_create_date        DATE
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4; -- Best practice for full Unicode support


-- ----------------------------------------------------------
-- CRM Product Information (bronze_crm_prd_info)
-- ----------------------------------------------------------
DROP TABLE IF EXISTS bronze_crm_prd_info; -- Safe drop for idempotency (optional but helpful)
CREATE TABLE bronze_crm_prd_info (
    prd_id         INT,
    prd_key        VARCHAR(50), 
    prd_nm         VARCHAR(50), 
    prd_cost       INT,
    prd_line       VARCHAR(50), 
    prd_start_dt   DATETIME,
    prd_end_dt     DATETIME
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4;


-- ----------------------------------------------------------
-- CRM Sales Details (bronze_crm_sales_details)
-- ----------------------------------------------------------
DROP TABLE IF EXISTS bronze_crm_sales_details;
CREATE TABLE bronze_crm_sales_details (
    sls_ord_num    VARCHAR(50), 
    sls_prd_key    VARCHAR(50), 
    sls_cust_id    INT,
    sls_order_dt   INT, -- Consider using DATE type here if storing YYYYMMDD
    sls_ship_dt    INT, -- Consider using DATE type here if storing YYYYMMDD
    sls_due_dt     INT, -- Consider using DATE type here if storing YYYYMMDD
    sls_sales      INT, -- Recommend DECIMAL(10, 2) or similar for currency/sales
    sls_quantity   INT,
    sls_price      INT  -- Recommend DECIMAL(10, 2) or similar for currency/price
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4;


-- ----------------------------------------------------------
-- ERP Location Data (bronze_erp_loc_a101)
-- ----------------------------------------------------------
DROP TABLE IF EXISTS bronze_erp_loc_a101;
CREATE TABLE bronze_erp_loc_a101 (
    cid            VARCHAR(50), 
    cntry          VARCHAR(50) 
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4;


-- ----------------------------------------------------------
-- ERP Customer Data (bronze_erp_cust_az12)
-- ----------------------------------------------------------
DROP TABLE IF EXISTS bronze_erp_cust_az12;
CREATE TABLE bronze_erp_cust_az12 (
    cid            VARCHAR(50), 
    bdate          DATE,
    gen            VARCHAR(50) 
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4;


-- ----------------------------------------------------------
-- ERP Product Category (erp_px_cat_g1v2)
-- ----------------------------------------------------------
DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;
CREATE TABLE bronze_erp_px_cat_g1v2 (
    id             VARCHAR(50), 
    cat            VARCHAR(50), 
    subcat         VARCHAR(50), 
    maintenance    VARCHAR(50) 
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4;
