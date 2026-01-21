# 🚀 n8n CSV Load - Complete Guide

## ⚠️ Path Problem Fixed!

n8n only allows file access from: `/home/node/.n8n-files`

## ✅ Solution (3 Steps)

### Step 1: Copy CSV to n8n folder

**Run this in CMD**:
```cmd
mkdir "%USERPROFILE%\.n8n\files"
copy "C:\Users\Nejra\Fakultet\PoslovnaInteligencija\Project\raw_data\data.csv" "%USERPROFILE%\.n8n\files\data.csv"
```

**Or use batch script**: `setup_n8n_csv.bat`

### Step 2: Verify workflow path

Workflow already updated to use: `/home/node/.n8n-files/data.csv`

### Step 3: Execute workflow

1. Open http://localhost:5678
2. Open "BI Project - ELT Pipeline"
3. Click "Execute Workflow"
4. Wait 5-15 minutes (540K rows)

## Verification

```sql
SELECT COUNT(*) FROM source_raw_transactions;
-- Expected: ~541,000
```

## Next Step

After CSV loads successfully:
```sql
-- Run in DBeaver:
database/09_MASTER_TRANSFORM.sql
```

**Full troubleshooting**: See local `N8N_CSV_LOAD_GUIDE.md`
