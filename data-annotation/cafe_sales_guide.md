Here is a professional **README file content** you can use for your Cafe Coffee Sales Data Cleaning & Dashboard project.

You can copy this directly into a `README.md` file or paste into a documentation sheet inside Excel.

---

# ☕ Cafe Coffee Sales Data

## Data Cleaning, Validation & Dashboard Strategy Documentation

---

# 1. Project Overview

This project focuses on cleaning, validating, and preparing a raw cafe sales dataset for dashboard visualization and sales performance analysis in Excel.

The original dataset contains 8 columns:

* Transaction ID
* Item
* Quantity
* Price Per Unit
* Total Spent
* Payment Method
* Location
* Transaction Date

The raw dataset contains multiple data quality issues including:

* "ERROR" values
* "UNKNOWN" values
* Blank cells
* Incorrect numeric relationships
* Inconsistent categorical entries

The objective is to clean and standardize the dataset to ensure accurate KPI calculation and dashboard reporting.

---

# 2. Data Cleaning Strategy

## A. Numeric Columns Cleaning

Columns affected:

* Quantity
* Price Per Unit
* Total Spent

### 2.1 Error Handling Rules

We applied the following logic rules:

### Rule 1: Drop Completely Invalid Transactions

If:

* Quantity = ERROR/UNKNOWN
  AND
* Total Spent = ERROR/UNKNOWN

➡ Delete the entire row (insufficient data for recovery).

---

### Rule 2: Recover Missing Quantity

If:

* Quantity = ERROR/UNKNOWN
* Price Per Unit = valid number
* Total Spent = valid number

Then:

Quantity = Total Spent ÷ Price Per Unit

---

### Rule 3: Recover Missing Total Spent

If:

* Quantity = valid number
* Price Per Unit = valid number
* Total Spent = ERROR/UNKNOWN

Then:

Total Spent = Quantity × Price Per Unit

---

### Rule 4: Validation Check

After cleaning:

Check that:

Quantity × Price Per Unit = Total Spent

If mismatch:

* Flag row as "Review Required"

---

## B. Categorical Columns Cleaning

Columns affected:

* Payment Method
* Location
* Transaction Date

### 2.2 Payment Method Cleaning

Common errors:

* ERROR
* UNKNOWN
* Blank

Strategy:

* Replace "ERROR" with blank
* If blank and cannot infer → label as "Not Recorded"
* Standardize categories:

  * Cash
  * Credit Card
  * Digital Wallet

Use Data Validation dropdown in Excel to restrict entries.

---

### 2.3 Location Cleaning

Valid categories:

* In-store
* Takeaway

Strategy:

* Replace ERROR with blank
* If cannot infer → label as "Not Recorded"
* Apply Data Validation List

---

### 2.4 Transaction Date Cleaning

Issues:

* ERROR
* UNKNOWN
* Invalid date formats

Strategy:

* Remove rows with invalid dates (critical for dashboard time analysis)
* Convert all dates to standard format:
  YYYY-MM-DD
* Use Excel:

  * DATEVALUE
  * Text to Columns
  * Power Query (recommended)

---

# 3. Validation Techniques Used

## 3.1 Logical Validation

Created validation column:

=IF(Quantity*PricePerUnit=TotalSpent,"Valid","Check")

Used Conditional Formatting to highlight mismatches.

---

## 3.2 Data Type Enforcement

* Quantity → Whole Number
* Price Per Unit → Currency
* Total Spent → Currency
* Transaction Date → Date
* Payment Method → Dropdown List
* Location → Dropdown List

---

## 3.3 Duplicate Detection

Used:
Home → Conditional Formatting → Highlight Duplicates
On Transaction ID column.

---

# 4. Final Dataset Quality After Cleaning

After applying all rules:

* All numeric relationships are consistent
* No ERROR / UNKNOWN in critical numeric fields
* All categories standardized
* Dates properly formatted
* Dataset ready for analytics & dashboard

---

# 5. Business Insights Enabled by Cleaning

After cleaning, the dataset allows:

* Accurate revenue calculation
* Reliable sales trend analysis
* Customer payment preference analysis
* Product performance comparison
* Location performance tracking
* KPI monitoring

---

# 6. Tools Used

* Microsoft Excel
* Pivot Tables
* Data Validation
* Conditional Formatting
* Power Query (optional)
* VBA Macros (optional automation)

---

# Conclusion

Through systematic data cleaning, validation, and structured recovery rules, the cafe sales dataset has been transformed from a raw, inconsistent dataset into a reliable analytical dataset ready for dashboard visualization and business decision-making.

---
