# Data Dictionary

## Source Schema

### source.raw_transactions
**Purpose**: Raw data landing zone - exact CSV structure

| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | SERIAL | NO | Auto-increment primary key |
| invoice_no | VARCHAR(20) | NO | Invoice number (C prefix = cancellation) |
| stock_code | VARCHAR(20) | NO | Product code |
| description | TEXT | YES | Product description |
| quantity | INTEGER | NO | Quantity (negative = return) |
| invoice_date | TIMESTAMP | NO | Transaction timestamp |
| unit_price | DECIMAL(10,2) | NO | Price per unit in GBP |
| customer_id | INTEGER | YES | Customer ID (NULL = anonymous) |
| country | VARCHAR(100) | NO | Customer country |

---

## Data Warehouse Schema

### dwh.dim_date
**Purpose**: Time dimension

| Column | Type | Description |
|--------|------|-------------|
| date_key | INTEGER | Date in YYYYMMDD format |
| full_date | DATE | Actual date value |
| day_of_week | INTEGER | 1=Monday, 7=Sunday |
| month | INTEGER | Month number (1-12) |
| quarter | INTEGER | Quarter (1-4) |
| year | INTEGER | Year |

### dwh.dim_customer
**Purpose**: Customer master

| Column | Type | Description |
|--------|------|-------------|
| customer_key | SERIAL | Surrogate key |
| customer_id | INTEGER | Natural key (-1 = Anonymous) |
| customer_segment | VARCHAR(20) | Regular, High Value, Low Value |
| is_anonymous | BOOLEAN | TRUE if customer_id = -1 |
| total_revenue | DECIMAL(12,2) | Lifetime revenue |

### dwh.dim_product
**Purpose**: Product catalog

| Column | Type | Description |
|--------|------|-------------|
| product_key | SERIAL | Surrogate key |
| stock_code | VARCHAR(20) | Product code |
| description | VARCHAR(500) | Product description |
| product_category | VARCHAR(50) | Category |
| average_price | DECIMAL(10,2) | Average price |

### dwh.fact_sales
**Purpose**: Transaction-level sales

| Column | Type | Description |
|--------|------|-------------|
| sale_id | BIGSERIAL | Surrogate key |
| date_key | INTEGER | FK to dim_date |
| customer_key | INTEGER | FK to dim_customer |
| product_key | INTEGER | FK to dim_product |
| quantity | INTEGER | Quantity (negative for returns) |
| unit_price | DECIMAL(10,2) | Price per unit |
| total_amount | DECIMAL(12,2) | Extended amount |
| is_return | BOOLEAN | Return flag |
| is_promotional | BOOLEAN | Free item flag |

---

## Business Rules

### Anonymous Customers
- NULL or 0 customer_id → customer_key = -1
- Grouped together for analysis
- ~25% of transactions

### Returns
- Negative quantity = return
- Tracked separately for return rate

### Promotional Items
- unit_price = 0 = free item
- Excluded from pricing analysis

**Author**: Nejra | **Date**: January 2026
