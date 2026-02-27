/* 
=========================================================
04_analysis_views.sql
Objective:
- Standardize financial metrics
- Enable business & executive analysis
- Serve as a trusted semantic layer
=========================================================
*/

-- ------------------------------------------------------
-- VIEW 1: Order Item Financials (Refund-Adjusted)
-- ------------------------------------------------------
DROP VIEW IF EXISTS vw_order_item_financials;
CREATE VIEW vw_order_item_financials AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.price_usd,
    oi.cogs_usd,
    COALESCE(r.refund_amount_usd, 0) AS refund_amount_usd,
    (oi.price_usd - COALESCE(r.refund_amount_usd, 0)) AS net_revenue_usd,
    (oi.price_usd - oi.cogs_usd - COALESCE(r.refund_amount_usd, 0)) AS net_profit_usd
FROM order_items oi
LEFT JOIN order_item_refund_records r
    ON oi.order_item_id = r.order_item_id;

-- ------------------------------------------------------
-- VIEW 2: Product-Level Profitability
-- ------------------------------------------------------
DROP VIEW IF EXISTS vw_product_profitability;
CREATE VIEW vw_product_profitability AS
SELECT
    product_id,
    COUNT(order_item_id) AS units_sold,
    SUM(price_usd) AS gross_revenue,
    SUM(cogs_usd) AS total_cogs,
    SUM(refund_amount_usd) AS total_refunds,
    SUM(net_revenue_usd) AS net_revenue,
    SUM(net_profit_usd) AS net_profit,
    ROUND(
        (SUM(net_profit_usd) / NULLIF(SUM(price_usd), 0)) * 100,
        2
    ) AS profit_margin_pct
FROM vw_order_item_financials
GROUP BY product_id;

-- ------------------------------------------------------
-- VIEW 3: Pareto / Promotion Analysis
-- ------------------------------------------------------
DROP VIEW IF EXISTS vw_product_pareto;
CREATE VIEW vw_product_pareto AS
SELECT
    product_id,
    net_profit,
    SUM(net_profit) OVER () AS total_company_profit,
    ROUND(
        (net_profit / SUM(net_profit) OVER ()) * 100,
        2
    ) AS profit_contribution_pct
FROM vw_product_profitability;

-- ------------------------------------------------------
-- VIEW 4: Executive Star Product Summary
-- ------------------------------------------------------
DROP VIEW IF EXISTS vw_star_products;
CREATE VIEW vw_star_products AS
SELECT
    product_id,
    net_revenue,
    net_profit,
    profit_margin_pct,
    CASE
        WHEN profit_margin_pct >= 40 THEN 'Star Product'
        ELSE 'Standard Performer'
    END AS product_classification
FROM vw_product_profitability
ORDER BY net_profit DESC;
