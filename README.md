# Covid-Analysis-Project

# 🦠 COVID-19 Data Analysis using SQL Server

## 📊 Project Overview

This project involves deep analysis of the [COVID-19 dataset by Our World in Data]( https://ourworldindata.org/covid-deaths), using **Microsoft SQL Server** as the backend tool. The data includes global statistics like total cases, total deaths, new cases, new deaths, vaccinations, and more — allowing us to perform exploratory analysis, aggregations, and transformations using SQL.

---

## 🔗 Dataset Source

📁 Importable Files Folder  
All parts of the dataset required for importing are available here:  
🔗 [COVID Import Files – Google Drive](https://drive.google.com/drive/folders/1XvnbvUXHcM9KIRyQknAEvoN18ui7WH4T?usp=drive_link)



---

## 🛠️ Tools & Technologies Used

- **Microsoft SQL Server 2022**
- **SQL Server Management Studio (SSMS)**
- **SQL Server Import and Export Wizard**
- **Microsoft Excel**

---

## ⚠️ Challenges Faced During Import

### 🚫 `.xlsx` Not Supported by Import Wizard

The **SQL Server Import and Export Wizard** does not allow importing `.xlsx` files directly. Trying to convert `.xlsx` to `.xls` (which is supported) led to **data loss**, as `.xls` only supports **65,536 rows**.

### ✅ Solution

- We **split the original CSV file** into smaller parts (with fewer rows) and saved them as `.xlsx`.
- Then, we used Excel’s **"Save As"** feature to convert each part to `.xls`, enabling smooth import into SQL Server without losing data.

### ❌ Columns Showing NULL Values

- Some columns like `total_deaths` and `new_deaths` showed **NULL values for every row** even when actual values existed.
- This happened due to:
  - Blank cells in Excel (interpreted as NULL).
  - Incorrect datatype mapping during import (e.g., mapping numbers as `varchar`).

### ✅ Fix

- **Replaced blank cells with `0` in Excel** before import.
- Ensured that each column was mapped to the **correct datatype** (e.g., `float` for numeric columns) during the import process.

---

## ✅ Final Dataset Preparation

After successful import:

- Blank values were **converted to 0** in Excel before importing.
- Proper **datatype mapping** was ensured (e.g., `float`, `int`, `nvarchar`).
- Both files were merged back in SQL Server for full analysis.

---

## 📌 SQL Features Demonstrated

### 🔗 1. Joins

- Joined `Combined_CovidDeaths` and `Combined_CovidVaccinations` to create a unified dataset.

### 📊 2. Aggregate Functions

- Used:
  - `SUM()` – Total deaths, total vaccinations, etc.
  - `AVG()` – Average new cases
  - `MAX()`/`MIN()` – Peak values

### 📈 3. `OVER()` Clause

Used to calculate:
- **Cumulative totals**
- **Running counts**
- **Rolling aggregates**

Example:
```sql
SUM(new_cases) OVER (PARTITION BY location ORDER BY date)
```
This provides a **cumulative sum of cases for each country over time**, by combining:

- `PARTITION BY` → Groups by each country  
- `ORDER BY` → Ensures chronological order within each country  

---

### 🧠 4. Common Table Expressions (CTEs)

Used `WITH` clauses to break down complex queries into simpler, modular components that are easier to understand and reuse.

---

### ⚡ 5. Temporary Tables

Created temporary tables to store intermediate query results. This helped with:

- Debugging
- Modular development
- Reusing intermediate datasets across multiple queries

---

## 📈 Outcome

By the end of this project, we were able to:

- ✅ Perform **detailed trend analysis** on COVID-19 cases and vaccinations
- ✅ Gain **hands-on experience** with SQL Server, real-world datasets, and practical data-cleaning techniques
- ✅ Master important SQL concepts like:
  - Joins
  - Aggregate functions
  - `OVER()` clause for cumulative stats
  - Common Table Expressions (CTEs)
  - Temporary Tables

All of this was done on a **real-world dataset** with common challenges like data size limits, format incompatibilities, and missing/null values — giving us both technical and problem-solving experience.

---

