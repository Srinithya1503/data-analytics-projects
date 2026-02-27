# Maven Toys – E-Commerce Profitability & Marketing Analytics

## Project Goal
To help an e-commerce brand understand its sales performance, refund risk,
and marketing efficiency using SQL-driven analysis.

## Tools Used
- PostgreSQL 18
- pgAdmin 4
- SQL (CTEs, Views, Window Functions)
- Excel (validation & summaries)

## Project Structure

maven-toys-ecommerce-analysis/
│
├── README.md
│
├── data/
│   ├── raw/
│   │   ├── orders.csv
│   │   ├── order_items.csv
│   │   ├── products.csv
│   │   ├── website_sessions.csv
│   │   └── website_pageviews.csv
│   │
│   └── synthetic/
│       └── order_item_refund_records.csv
├── sql/
│   ├── 01_data_schema.sql
│   ├── 02_data_validation.sql
│   ├── 03_refund_data_generation.sql
│   ├── 04_analysis_views.sql
│   ├── 05_business_analysis.sql
│   └── 06_product_profitability.sql
├── docs/
│   ├── Assumptions_and_Data_Gaps.md
│   ├── BRD.md
│   ├── Executive_Summary_Report.md 
│   └── Stakeholder_Insights_Summary.md



## STAR Method Summary

### Situation
The company operates a four-product catalog with no recorded refunds, creating an unrealistic view of profitability and marketing efficiency.

### Task
Validate the data, introduce real-world business behavior, and deliver analysis that supports marketing and pricing decisions.

### Action
- Validated datasets and confirmed 0% data leakage
- Introduced a synthetic 5% refund rate to model real operational risk
- Built analysis-ready SQL views for profitability and refund tracking
- Performed cohort and cross-sell analysis to understand customer behavior
- Calculated product-level breakeven CAC

### Result
- Identified a gift-based, low-retention business model
- Defined a clear breakeven CAC of $28.49 for the top-performing product
- Provided marketing teams with a defensible acquisition budget
- Highlighted a strategic opportunity for a missing premium-tier product

---
## Key Insights
- Product 1 acts as the primary anchor for cross-sell behavior
- 98% of customers are one-time purchasers, confirming a gift-driven model
- Refund rates remain below 4%, preserving margin integrity
- Clear breakeven CAC thresholds enable disciplined marketing spend
- Portfolio shows opportunity for premium tier expansion

## Next Steps
- Build Power BI dashboards for executive reporting
- Simulate new product launches for portfolio expansion analysis
- Extend customer-level retention modeling


