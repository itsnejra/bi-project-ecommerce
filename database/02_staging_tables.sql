-- ============================================================================
-- File: 02_staging_tables.sql
-- Purpose: Staging schema - Cleaned and validated data
-- Author: Nejra
-- Date: January 2026
-- ============================================================================

DROP TABLE IF EXISTS staging.clean_transactions CASCADE;

CREATE TABLE staging.clean_transactions (
    transaction_id SERIAL PRIMARY KEY,
    invoice_no VARCHAR(20) NOT NULL,
    stock_code VARCHAR(20) NOT NULL,
    description VARCHAR(500) NOT NULL DEFAULT 'Unknown Product',
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    total_amount DECIMAL(12, 2) NOT NULL,
    invoice_date TIMESTAMP NOT NULL,
    customer_id INTEGER NOT NULL DEFAULT -1, -- -1 = Anonymous
    country VARCHAR(100) NOT NULL,
    is_return BOOLEAN NOT NULL DEFAULT FALSE,
    is_promotional BOOLEAN NOT NULL DEFAULT FALSE,
    is_cancellation BOOLEAN NOT NULL DEFAULT FALSE,
    has_description BOOLEAN NOT NULL DEFAULT TRUE,
    is_valid_price BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_id INTEGER REFERENCES source.raw_transactions(id)
);

CREATE INDEX idx_staging_invoice_no ON staging.clean_transactions(invoice_no);
CREATE INDEX idx_staging_customer_id ON staging.clean_transactions(customer_id);
CREATE INDEX idx_staging_invoice_date ON staging.clean_transactions(invoice_date);

COMMENT ON TABLE staging.clean_transactions IS 'Cleaned transactions with business rules applied';