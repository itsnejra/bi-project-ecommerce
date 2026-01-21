# 🚀 BI Project - Complete Execution Guide

## 📋 Quick Start

**Prerequisites**: PostgreSQL + n8n + Superset running

**Steps**:
1. Load CSV via n8n workflow (http://localhost:5678)
2. Run transformation scripts (database/04-08)
3. Verify data warehouse
4. Connect Superset
5. Build dashboards

## Detailed Instructions

See full execution guide in repository.

**CSV File**: `raw_data/data.csv` (~540K rows)
**Workflow**: "BI Project - ELT Pipeline"
**Database**: ecommerce (schemas: source, staging, dwh)

## Transformation Scripts (Execute in Order)

```
04_populate_dim_date.sql       # Date dimension (730 days)
05_populate_dim_country.sql    # Countries (~38)
06_populate_dim_product.sql    # Products (~4K)
07_populate_dim_customer.sql   # Customers (~4.3K + Anonymous)
08_populate_fact_sales.sql     # Sales (~540K)
```

## Verification Query

```sql
SELECT table_name, COUNT(*) as rows
FROM (
  SELECT 'source' as table_name FROM source_raw_transactions
  UNION ALL SELECT 'dim_date' FROM dwh_dim_date
  UNION ALL SELECT 'dim_customer' FROM dwh_dim_customer
  UNION ALL SELECT 'dim_product' FROM dwh_dim_product
  UNION ALL SELECT 'dim_country' FROM dwh_dim_country
  UNION ALL SELECT 'fact_sales' FROM dwh_fact_sales
) t GROUP BY table_name;
```

**Repository**: https://github.com/itsnejra/bi-project-ecommerce
