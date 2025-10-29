/*
Script Purpose:
  This script creates a new database after checking
  if it already exists. If the database exists, it is dropped and recreated.
=========================================================================


WARNING:
  Running this script will drop the entire database if it exists.
  All data in the database will be permanently deleted. Proceed with caution and
  ensure you have proper backups before running this script.
*/


-- =========================================================================
-- MySQL Data Warehouse Setup Script: Medallion Architecture (B/S/G)
-- File: data_warehouse_medallion_setup.sql
-- Description: Creates the three core databases (Bronze, Silver, Gold)
--              to implement a data warehousing medallion architecture in MySQL.
--              The entire script is idempotent (safe to run multiple times).
-- =========================================================================

-- SET SQL MODE to ensure compatibility and strict syntax adherence (optional)
SET SQL_MODE = "TRADITIONAL";

-- =============================================
-- 1. CLEANUP (Drop Databases if they exist)
--    Purpose: Allows the script to be safely rerun for environment rebuilds.
-- =============================================
DROP DATABASE IF EXISTS DataWarehouse_Gold;
DROP DATABASE IF EXISTS DataWarehouse_Silver;
DROP DATABASE IF EXISTS DataWarehouse_Bronze;


-- =============================================
-- 2. DATABASE CREATION (Bronze, Silver, Gold)
--    Purpose: Creates the three logical layers.
-- =============================================
CREATE DATABASE IF NOT EXISTS DataWarehouse_Bronze;
CREATE DATABASE IF NOT EXISTS DataWarehouse_Silver;
CREATE DATABASE IF NOT EXISTS DataWarehouse_Gold;


-- ==========================================================
-- 3. BRONZE LAYER (RAW DATA)
--    Purpose: Ingests data as-is from source systems.
-- ==========================================================
USE DataWarehouse_Bronze;

CREATE TABLE IF NOT EXISTS raw_customer_data (
    -- Source data columns, including potential dirty/raw fields
    raw_customer_id VARCHAR(50) NOT NULL,
    raw_name_field VARCHAR(255) NULL,
    raw_email_field VARCHAR(255) NULL,
    raw_source_system VARCHAR(50) NULL,
    -- Metadata fields for auditing and reprocessing
    ingestion_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    KEY (raw_customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================================
-- 4. SILVER LAYER (CLEANED & INTEGRATED DATA)
--    Purpose: Cleansed, validated, and conformed data (Dimensions & Facts).
-- ==========================================================
USE DataWarehouse_Silver;

-- Dimension Table Example: Customer (Implementing SCD Type 2)
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Surrogate Key
    customer_id_source VARCHAR(50) NOT NULL,             -- Natural Key
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NULL,
    current_address TEXT NULL,
    valid_from DATETIME NOT NULL,
    valid_to DATETIME NULL,
    is_current BOOLEAN NOT NULL DEFAULT TRUE,
    KEY (customer_id_source),
    KEY (is_current)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fact Table Example: Orders
CREATE TABLE IF NOT EXISTS fact_orders (
    order_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_key INT NOT NULL, -- Foreign Key to dim_customer
    order_amount DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    -- Foreign Key Constraint (Assumes dim_customer is populated)
    CONSTRAINT fk_customer FOREIGN KEY (customer_key)
        REFERENCES dim_customer (customer_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================================
-- 5. GOLD LAYER (CURATED & AGGREGATED DATA)
--    Purpose: High-value, highly aggregated data optimized for BI/Reporting.
-- ==========================================================
USE DataWarehouse_Gold;

-- Summary Table Example: Daily Sales Aggregation
CREATE TABLE IF NOT EXISTS fact_daily_sales (
    date_key INT NOT NULL PRIMARY KEY,
    total_revenue DECIMAL(12, 2) NOT NULL,
    total_orders INT NOT NULL,
    average_order_value DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Summary Table Example: Customer Lifetime Value (CLV)
CREATE TABLE IF NOT EXISTS summary_customer_spend (
    customer_key INT NOT NULL PRIMARY KEY,
    lifetime_spend
