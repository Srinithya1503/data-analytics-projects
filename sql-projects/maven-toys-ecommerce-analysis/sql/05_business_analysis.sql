/* 
=========================================================
05_business_analysis.sql
Objective:
- Understand customer behavior
- Identify cross-sell opportunities
- Assess lifecycle & portfolio gaps
=========================================================
*/

-- ------------------------------------------------------
-- 1. Product Affinity (Cross-Sell Analysis)
-- Business Question:
-- "Which products are bought together?"
-- ------------------------------------------------------
SELECT
    oi1.product_id AS product_a,
    oi2.product_id AS product_b,
    COUNT(DISTINCT oi1.order_id) AS orders_together
FROM order_items oi1
JOIN order_items oi2
    ON oi1.order_id = oi2.order_id
   AND oi1.product_id < oi2.product_id
GROUP BY 1, 2
ORDER BY orders_together DESC;

-- ------------------------------------------------------
-- 2. Customer Purchase Depth
-- Business Question:
-- "Are customers buying more than one product?"
-- ------------------------------------------------------
SELECT
    o.user_id,
    COUNT(DISTINCT oi.product_id) AS distinct_products_bought,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.user_id
ORDER BY distinct_products_bought DESC;

-- ------------------------------------------------------
-- 3. Gift-Based Behavior Indicator
-- Business Question:
-- "Is this a repeat-purchase business?"
-- ------------------------------------------------------
SELECT
    COUNT(*) FILTER (WHERE total_orders = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_customers
FROM (
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY user_id
) t;

-- ------------------------------------------------------
-- 4. Gap Analysis 
-- Business Question:
-- "Is there room for a premium or budget product?"
-- ------------------------------------------------------
SELECT
    ROUND(AVG(price_usd), 2) AS avg_price,
    ROUND(AVG(cogs_usd), 2) AS avg_cogs,
    ROUND(AVG(price_usd - cogs_usd), 2) AS avg_unit_margin
FROM order_items;
