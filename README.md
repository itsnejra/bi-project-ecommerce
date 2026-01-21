# BI Project: ELT, Data Warehouse & Visualization

## 🎯 Project Overview

Comprehensive Business Intelligence system for analyzing online retail transactions.

**Stack**: PostgreSQL + n8n + Apache Superset

**Features**:
- ✅ ELT Pipeline Automation
- ✅ Star Schema Data Warehouse  
- ✅ Interactive Dashboards
- ✅ Data Quality Management

## 📊 Quick Stats
- **Dataset**: ~540K transactions (2010-2011)
- **Geography**: 38+ countries
- **Primary Market**: UK-based e-commerce
- **Business Challenge**: 25% anonymous transactions

## 🏗️ Architecture

```
CSV → SOURCE → STAGING → DWH (Star Schema) → Superset Dashboards
```

## 📂 Project Structure

- `database/` - DDL scripts (schemas, tables, views)
- `etl/` - n8n workflows and transformation queries
- `superset/` - Dashboard exports
- `docs/` - Full documentation

## 📚 Documentation

- [Full README](docs/README.md)
- [Business Questions & KPIs](docs/BUSINESS_QUESTIONS.md)
- [Data Dictionary](docs/DATA_DICTIONARY.md)

## 🚀 Quick Start

1. Run DDL scripts in `database/`
2. Import n8n workflow from `etl/`
3. Configure Superset connection
4. Import dashboards

## 👨‍💻 Author

**Nejra Smajlovic**  
University Project - Business Intelligence  
January 2026
