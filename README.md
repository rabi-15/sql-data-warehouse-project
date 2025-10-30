# 🚀 MySQL Data Warehouse Project

## Project Overview

This project is a modern, end-to-end Data Warehouse built completely from scratch using **MySQL**. It applies best practices in data engineering and database design to ingest, clean, transform, and organize data for advanced analytics and business intelligence.

The architecture follows the **Medallion pattern** , organizing data into three refined layers for scalable and modular data processing:

* **Bronze Layer:** Raw data ingestion from source systems as-is.
* **Silver Layer:** Cleaned and standardized data for quality and consistency.
* **Gold Layer:** Business-ready star schema models with analytical views and KPIs.

## ✨ Features & Highlights

* Fully designed and developed in **MySQL**.
* **Robust ETL stored procedures** automate data ingestion and transformations.
* Optimized **indexing and foreign key constraints** ensure data integrity and query performance.
* Use of advanced MySQL features like **generated columns**, transactions, and error handling.
* Comprehensive **data quality validation** scripts.
* Insightful analytical views on customer behavior, product performance, sales trends, and business metrics.

## 📁 Project Structure

- `mysql-data-warehouse-project/`
  - `datasets/` — Sample CSV files for ingestion
  - `docs/` — Documentation and design notes
  - `scripts/` — SQL scripts for schema setup, ETL, and analytics
    - `00_setup/` — Database and schema creation scripts
    - `bronze/` — Bronze layer tables and load procedures
    - `silver/` — Silver layer tables and load procedures
    - `gold/` — Gold layer analytical views and queries
  - `tests/` — Data quality and validation scripts
  - `config/` — Configuration files
  - `README.md` — Project overview and instructions
  - `.gitignore` — Git ignore rules



## ⚙️ Getting Started

Prerequisites

* MySQL Server 8.0 or later installed.
* Access to MySQL client or MySQL Workbench
* Basic knowledge of SQL and data warehouses

## 📈 Usage & Analytics

* Query the Gold layer views for direct business insights.
* Schedule ELT stored procedures for automated pipeline runs.
* Monitor data quality reports regularly to maintain accuracy.

## ✉️ Contact

* Abishek R
* Email: abishek2004r@gmail.com
* LinkedIn: www.linkedin.com/in/abishek15rabi






