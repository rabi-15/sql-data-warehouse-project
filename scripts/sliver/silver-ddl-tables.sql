-- =============================================
-- Silver Layer DDL Scripts for MySQL
-- Description: Creates cleaned and standardized tables in Silver layer
-- Converted from SQL Server to MySQL
-- =============================================

USE data_warehouse;

-- =============================================
-- SILVER LAYER MASTER TABLES
-- =============================================

-- Silver Customer Master Table (Consolidated from CRM and ERP)
DROP TABLE IF EXISTS silver_customer_master;
CREATE TABLE silver_customer_master (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_key VARCHAR(50) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    customer_address VARCHAR(255),
    customer_city VARCHAR(50),
    customer_state VARCHAR(50),
    customer_country VARCHAR(50),
    customer_zipcode VARCHAR(10),
    source_system VARCHAR(10) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer_key (customer_key),
    INDEX idx_customer_name (customer_name),
    INDEX idx_source_system (source_system)
) ENGINE=InnoDB;

-- Silver Product Master Table (Consolidated from CRM and ERP)
DROP TABLE IF EXISTS silver_product_master;
CREATE TABLE silver_product_master (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_key VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50),
    product_subcategory VARCHAR(50),
    product_brand VARCHAR(50),
    product_price DECIMAL(10,2),
    product_cost DECIMAL(10,2),
    profit_margin DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN product_price > 0 
            THEN ((product_price - product_cost) / product_price) * 100 
            ELSE 0 
        END
    ) STORED,
    source_system VARCHAR(10) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_product_key (product_key),
    INDEX idx_product_name (product_name),
    INDEX idx_product_category (product_category),
    INDEX idx_source_system (source_system)
) ENGINE=InnoDB;

-- Silver Sales Fact Table (Consolidated from CRM and ERP)
DROP TABLE IF EXISTS silver_sales_fact;
CREATE TABLE silver_sales_fact (
    sales_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    product_key VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    ship_date DATE,
    quantity INT NOT NULL DEFAULT 0,
    unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    sales_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    net_sales_amount DECIMAL(10,2) GENERATED ALWAYS AS (
        sales_amount - IFNULL(discount_amount, 0)
    ) STORED,
    source_system VARCHAR(10) NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id),
    INDEX idx_customer_key (customer_key),
    INDEX idx_product_key (product_key),
    INDEX idx_order_date (order_date),
    INDEX idx_source_system (source_system),
    INDEX idx_sales_amount (sales_amount),
    FOREIGN KEY (customer_key) REFERENCES silver_customer_master(customer_key),
    FOREIGN KEY (product_key) REFERENCES silver_product_master(product_key)
) ENGINE=InnoDB;

-- Silver Date Dimension Table
DROP TABLE IF EXISTS silver_date_dimension;
CREATE TABLE silver_date_dimension (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    week INT NOT NULL,
    day_of_year INT NOT NULL,
    day_of_month INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_holiday BOOLEAN DEFAULT FALSE,
    fiscal_year INT,
    fiscal_quarter INT,
    INDEX idx_year (year),
    INDEX idx_month (month),
    INDEX idx_quarter (quarter)
) ENGINE=InnoDB;

-- Display completion message
SELECT 'Silver layer tables created successfully!' as Status;
