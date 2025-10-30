-- gold.dim_customers table
CREATE TABLE gold_dim_customers (
    customer_key INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
) ENGINE=InnoDB;


-- gold.dim_products table
CREATE TABLE gold_dim_products (
    product_key INT NOT NULL PRIMARY KEY,
    product_id INT NOT NULL,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance_required VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
) ENGINE=InnoDB;


-- gold.fact_sales table
CREATE TABLE gold_fact_sales (
    order_number VARCHAR(50) NOT NULL,
    product_key INT NOT NULL,
    customer_key INT NOT NULL,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity INT,
    price INT,
    PRIMARY KEY (order_number, product_key, customer_key),
    FOREIGN KEY (product_key) REFERENCES gold_dim_products(product_key),
    FOREIGN KEY (customer_key) REFERENCES gold_dim_customers(customer_key)
) ENGINE=InnoDB;
