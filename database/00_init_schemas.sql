-- ============================================================================
-- File: 00_init_schemas.sql
-- Purpose: Initialize database schemas for BI Project
-- Author: Nejra
-- Date: January 2026
-- ============================================================================

-- Drop schemas if they exist (for clean reinstall)
DROP SCHEMA IF EXISTS source CASCADE;
DROP SCHEMA IF EXISTS staging CASCADE;
DROP SCHEMA IF EXISTS dwh CASCADE;

-- Create schemas
CREATE SCHEMA source;
CREATE SCHEMA staging;
CREATE SCHEMA dwh;

-- Add comments
COMMENT ON SCHEMA source IS 'Raw data landing zone - direct CSV load';
COMMENT ON SCHEMA staging IS 'Cleaned and validated data';
COMMENT ON SCHEMA dwh IS 'Star Schema - Dimensional Model for OLAP';

-- Grant permissions (adjust username as needed)
-- GRANT ALL PRIVILEGES ON SCHEMA source TO your_username;
-- GRANT ALL PRIVILEGES ON SCHEMA staging TO your_username;
-- GRANT ALL PRIVILEGES ON SCHEMA dwh TO your_username;

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'Schemas created successfully:';
    RAISE NOTICE '  - source (Raw data)';
    RAISE NOTICE '  - staging (Cleaned data)';
    RAISE NOTICE '  - dwh (Star Schema)';
END $$;