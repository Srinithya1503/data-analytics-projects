/* 
=========================================================
06_product_profitability.sql
Objective:
- Measure true profitability
- Enable marketing budget decisions
=========================================================
*/

-- ------------------------------------------------------
-- 1. Net Profit & Margin per Product
-- ------------------------------------------------------
SELECT
    product_id,
    units_sold,
    gross_revenue,
    total_cogs,
    total_refunds,
    net_profit,
    profit_margin_pct
FROM vw_product_profitability
ORDER BY net_profit DESC;

-- ------------------------------------------------------
-- 2. Refund Risk Indicator
-- Business Question:
-- "Which products create post-sale risk?"
-- ------------------------------------------------------
SELECT
    product_id,
    ROUND(
        (total_refunds / NULLIF(gross_revenue, 0)) * 100,
        2
    ) AS refund_ratio_pct
FROM vw_product_profitability
ORDER BY refund_ratio_pct DESC;

-- ------------------------------------------------------
-- 3. Breakeven CAC Calculation
-- Business Question:
-- "How much can we spend to acquire a customer?"
-- ------------------------------------------------------
SELECT
    product_id,
    ROUND(net_profit / units_sold, 2) AS profit_per_unit,
    ROUND(net_profit / units_sold, 2) AS breakeven_cac
FROM vw_product_profitability
ORDER BY breakeven_cac DESC;
