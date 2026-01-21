-- ============================================================================
-- File: 01_source_tables.sql
-- Purpose: Source schema - Raw data landing tables
-- Author: Nejra
-- Date: January 2026
-- Description: Mirrors CSV structure with minimal transformation
-- ============================================================================

DROP TABLE IF EXISTS source.raw_transactions CASCADE;

CREATE TABLE source.raw_transactions (
    id SERIAL PRIMARY KEY,
    invoice_no VARCHAR(20) NOT NULL,
    stock_code VARCHAR(20) NOT NULL,
    description TEXT,
    quantity INTEGER NOT NULL,
    invoice_date TIMESTAMP NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    customer_id INTEGER,
    country VARCHAR(100) NOT NULL,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_file VARCHAR(255) DEFAULT 'data.csv'
);

CREATE INDEX idx_source_invoice_no ON source.raw_transactions(invoice_no);
CREATE INDEX idx_source_customer_id ON source.raw_transactions(customer_id);
CREATE INDEX idx_source_invoice_date ON source.raw_transactions(invoice_date);
CREATE INDEX idx_source_country ON source.raw_transactions(country);

COMMENT ON TABLE source.raw_transactions IS 'Raw e-commerce transactions loaded directly from CSV file';