-- =============================================
-- MySQL Data Warehouse Setup Script
-- Description: Creates database and schemas for MySQL data warehouse
-- Converted from SQL Server to MySQL
-- =============================================

-- Create the data warehouse database
DROP DATABASE IF EXISTS data_warehouse;
CREATE DATABASE data_warehouse 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Use the data warehouse database
USE data_warehouse;

-- Create schemas (MySQL uses databases as schema equivalents, so we'll use prefixes)
-- Bronze schema tables will be prefixed with bronze_
-- Silver schema tables will be prefixed with silver_
-- Gold schema will use views with gold_ prefix

-- Display success message
SELECT 'Database and schema structure created successfully!' as Status;
