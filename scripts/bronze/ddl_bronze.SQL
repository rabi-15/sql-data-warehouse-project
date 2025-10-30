USE data_warehouse;

-- =============================================
-- CRM SOURCE SYSTEM TABLES
-- =============================================

-- CRM Customer Info Table
DROP TABLE IF EXISTS bronze_crm_customer_info;
CREATE TABLE bronze_crm_customer_info (
    ID INT NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    customer_address VARCHAR(255),
    customer_city VARCHAR(50),
    customer_state VARCHAR(50),
    customer_country VARCHAR(50),
    customer_zipcode VARCHAR(10),
    created_date DATETIME,
    PRIMARY KEY (ID),
    INDEX idx_customer_key (customer_key)
) ENGINE=InnoDB;

-- CRM Product Info Table  
DROP TABLE IF EXISTS bronze_crm_product_info;
CREATE TABLE bronze_crm_product_info (
    ID INT NOT NULL,
    product_key VARCHAR(50) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50),
    product_subcategory VARCHAR(50),
    product_brand VARCHAR(50),
    product_price DECIMAL(10,2),
    product_cost DECIMAL(10,2),
    created_date DATETIME,
    PRIMARY KEY (ID),
    INDEX idx_product_key (product_key)
) ENGINE=InnoDB;

-- CRM Sales Details Table
DROP TABLE IF EXISTS bronze_crm_sales_details;
CREATE TABLE bronze_crm_sales_details (
    ID INT NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    product_key VARCHAR(50) NOT NULL,
    order_date DATE,
    ship_date DATE,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    sales_amount DECIMAL(10,2),
    created_date DATETIME,
    PRIMARY KEY (ID),
    INDEX idx_order_id (order_id),
    INDEX idx_customer_key (customer_key),
    INDEX idx_product_key (product_key),
    INDEX idx_order_date (order_date)
) ENGINE=InnoDB;

-- =============================================
-- ERP SOURCE SYSTEM TABLES  
-- =============================================

-- ERP Customer Info Table
DROP TABLE IF EXISTS bronze_erp_customer_info;
CREATE TABLE bronze_erp_customer_info (
    ID INT NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    customer_address VARCHAR(255),
    customer_city VARCHAR(50),
    customer_state VARCHAR(50),
    customer_country VARCHAR(50),
    customer_zipcode VARCHAR(10),
    created_date DATETIME,
    PRIMARY KEY (ID),
    INDEX idx_customer_key (customer_key)
) ENGINE=InnoDB;

-- ERP Product Info Table
DROP TABLE IF EXISTS bronze_erp_product_info;
CREATE TABLE bronze_erp_product_info (
    ID INT NOT NULL,
    product_key VARCHAR(50) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50),
    product_subcategory VARCHAR(50),
    product_brand VARCHAR(50),
    product_price DECIMAL(10,2),
    product_cost DECIMAL(10,2),
    created_date DATETIME,
    PRIMARY KEY (ID),
    INDEX idx_product_key (product_key)
) ENGINE=InnoDB;

-- ERP Sales Details Table
DROP TABLE IF EXISTS bronze_erp_sales_details;
CREATE TABLE bronze_erp_sales_details (
    ID INT NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    product_key VARCHAR(50) NOT NULL,
    order_date DATE,
    ship_date DATE,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    sales_amount DECIMAL(10,2),
    created_date DATETIME,
    PRIMARY KEY (ID),
    INDEX idx_order_id (order_id),
    INDEX idx_customer_key (customer_key),
    INDEX idx_product_key (product_key),
    INDEX idx_order_date (order_date)
) ENGINE=InnoDB;

-- Completion message
SELECT 'Bronze layer tables created successfully!' AS Status;
