-- ============================================================================
-- File: 03_dwh_tables.sql
-- Purpose: Data Warehouse - Star Schema (Kimball Methodology)
-- Author: Nejra
-- Date: January 2026
-- ============================================================================

-- DIMENSION TABLES

-- dim_date: Time Dimension
DROP TABLE IF EXISTS dwh.dim_date CASCADE;
CREATE TABLE dwh.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    day_name VARCHAR(10) NOT NULL,
    day_of_month INTEGER NOT NULL,
    week_of_year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    quarter INTEGER NOT NULL,
    year INTEGER NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    fiscal_year INTEGER NOT NULL
);

-- dim_customer: Customer Dimension (SCD Type 2)
DROP TABLE IF EXISTS dwh.dim_customer CASCADE;
CREATE TABLE dwh.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    customer_segment VARCHAR(20) DEFAULT 'Regular',
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    first_purchase_date DATE,
    total_orders INTEGER DEFAULT 0,
    total_revenue DECIMAL(12, 2) DEFAULT 0,
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);

-- dim_product: Product Dimension
DROP TABLE IF EXISTS dwh.dim_product CASCADE;
CREATE TABLE dwh.dim_product (
    product_key SERIAL PRIMARY KEY,
    stock_code VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(500) NOT NULL,
    product_category VARCHAR(50) DEFAULT 'Uncategorized',
    is_special_code BOOLEAN NOT NULL DEFAULT FALSE,
    average_price DECIMAL(10, 2)
);

-- dim_country: Country Dimension
DROP TABLE IF EXISTS dwh.dim_country CASCADE;
CREATE TABLE dwh.dim_country (
    country_key SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    region VARCHAR(50),
    is_domestic BOOLEAN NOT NULL DEFAULT FALSE
);

-- FACT TABLE

-- fact_sales: Sales Fact Table
DROP TABLE IF EXISTS dwh.fact_sales CASCADE;
CREATE TABLE dwh.fact_sales (
    sale_id BIGSERIAL PRIMARY KEY,
    date_key INTEGER NOT NULL REFERENCES dwh.dim_date(date_key),
    customer_key INTEGER NOT NULL REFERENCES dwh.dim_customer(customer_key),
    product_key INTEGER NOT NULL REFERENCES dwh.dim_product(product_key),
    country_key INTEGER NOT NULL REFERENCES dwh.dim_country(country_key),
    invoice_no VARCHAR(20) NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    is_return BOOLEAN NOT NULL DEFAULT FALSE,
    is_promotional BOOLEAN NOT NULL DEFAULT FALSE,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for query performance
CREATE INDEX idx_fact_sales_date ON dwh.fact_sales(date_key);
CREATE INDEX idx_fact_sales_customer ON dwh.fact_sales(customer_key);
CREATE INDEX idx_fact_sales_product ON dwh.fact_sales(product_key);
CREATE INDEX idx_fact_sales_country ON dwh.fact_sales(country_key);

-- VIEWS FOR SUPERSET

CREATE OR REPLACE VIEW dwh.vw_sales_summary AS
SELECT 
    d.year, d.month, d.month_name,
    c.country_name,
    cust.customer_segment,
    COUNT(DISTINCT f.invoice_no) as total_orders,
    SUM(CASE WHEN f.is_return = FALSE THEN f.total_amount ELSE 0 END) as net_revenue,
    SUM(f.quantity) as total_units
FROM dwh.fact_sales f
JOIN dwh.dim_date d ON f.date_key = d.date_key
JOIN dwh.dim_country c ON f.country_key = c.country_key
JOIN dwh.dim_customer cust ON f.customer_key = cust.customer_key
GROUP BY d.year, d.month, d.month_name, c.country_name, cust.customer_segment;

COMMENT ON TABLE dwh.fact_sales IS 'Transaction-level sales fact table (grain: one row per line item)';