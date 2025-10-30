🚀 Data Warehouse and Analytics Project
Welcome to the **Data Warehouse and Analytics Project** repository!

📊 Overview
## Project Overview

This project is an end-to-end implementation of a modern Data Warehouse built from scratch using MySQL. It applies best practices in data engineering to ingest, clean, transform, and organize data for advanced analytics and business intelligence.

The architecture follows the well-known Medallion pattern, organizing data into three refined layers:

- **Bronze Layer:** Raw data ingestion from multiple source systems as-is.
- **Silver Layer:** Cleaned and standardized data for consistency and quality.
- **Gold Layer:** Business-ready star schema models with analytical views and KPIs.

***

## Features & Highlights

- Designed and developed a scalable and modular data warehouse entirely in MySQL.
- Created robust ETL stored procedures to automate data loads and transformations.
- Defined optimized indexing and foreign key constraints to ensure data integrity and query performance.
- Implemented advanced MySQL features such as generated columns, transactions, and error handling.
- Provided comprehensive data quality validation scripts to maintain data accuracy.
- Built insightful analytical views targeting customer behavior, product performance, sales trends, and key business metrics.
- Documented the architecture, design decisions, and usage instructions clearly.

***

## Project Structure

```
mysql-data-warehouse-project/
│
├── datasets/                    # Sample data CSV files for ingestion
├── docs/                        # Project documentation and notes
├── scripts/                     # SQL scripts for schema, ETL, and analytics
│   ├── 00_setup/                # Database and schema creation scripts
│   ├── bronze/                  # Bronze layer tables and load procedures
│   ├── silver/                  # Silver layer tables and load procedures
│   └── gold/                    # Gold layer analytical views and queries
├── tests/                       # Data quality and validation scripts
├── config/                      # Configuration files
├── README.md                    # Project overview and instructions
└── .gitignore                   # Git ignore rules
```

***

## Getting Started

### Prerequisites

- MySQL Server 8.0 or later installed
- Access to MySQL client or MySQL Workbench
- Basic knowledge of SQL and data warehouses

### Setup Instructions

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd mysql-data-warehouse-project
   ```

2. Create database and schemas:
   ```sql
   SOURCE scripts/00_setup/create_database.sql;
   ```

3. Create and load Bronze layer tables:
   ```sql
   SOURCE scripts/bronze/ddl_bronze_tables.sql;
   SOURCE scripts/bronze/proc_load_bronze.sql;
   CALL load_bronze_layer();
   ```

4. Create and load Silver layer tables:
   ```sql
   SOURCE scripts/silver/ddl_silver_tables.sql;
   SOURCE scripts/silver/proc_load_silver.sql;
   CALL load_silver_layer();
   ```

5. Create Gold layer views:
   ```sql
   SOURCE scripts/gold/create_gold_views.sql;
   ```

6. Run data quality checks:
   ```sql
   SOURCE tests/data-quality-checks.sql;
   ```

***

## Usage & Analytics

- Query the Gold layer views for business insights.
- Schedule the ETL stored procedures for automated pipeline execution.
- Monitor data quality reports regularly.

***

## Design Decisions

- Followed modular design for scalability and maintainability.
- Used InnoDB for reliable ACID transactions and foreign key support.
- Leveraged MySQL generated columns for calculated fields.
- Applied normalized Silver layer to reduce redundancy.
- Structured Gold layer with star schemas for efficient analytics.

***

## Skills Demonstrated

- Designing and building a data architecture from scratch
- Writing complex ETL logic in MySQL stored procedures
- Managing data integrity and relationships with foreign keys
- Performing data quality validations and error handling
- Creating analytic models and business KPIs using SQL views
- Documenting technical projects professionally

***

## Contact

For questions or further discussion, please reach out at:

- Abishek R
- Email: absihek2004r@gmail.com
- linkedin: www.linkedin.com/in/abishek15rabi
- GitHub: https://github.com/rabi-15

