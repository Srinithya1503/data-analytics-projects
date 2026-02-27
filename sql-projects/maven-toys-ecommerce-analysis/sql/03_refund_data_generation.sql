/* 
=========================================================
03_refund_data_generation.sql
Objective:
- Introduce realistic refund behavior (5% rate)
- Preserve financial integrity
- Enable downstream profitability analysis
=========================================================
*/

-- ------------------------------------------------------
-- STEP 0: Reproducibility (optional but recommended)
-- ------------------------------------------------------
-- Ensures consistent random sampling across runs
SELECT setseed(0.42);

-- ------------------------------------------------------
-- STEP 1: Identify refund-eligible order items
-- Business Rule: Only items with positive revenue
-- ------------------------------------------------------
DROP VIEW IF EXISTS vw_refund_candidates;
CREATE VIEW vw_refund_candidates AS
SELECT
    oi.order_item_id,
    oi.product_id,
    oi.price_usd,
    oi.cogs_usd
FROM order_items oi
WHERE oi.price_usd > 0;

-- ------------------------------------------------------
-- STEP 2: Select exactly 5% of items for refunds
-- Non-biased random sample
-- ------------------------------------------------------
DROP TABLE IF EXISTS synthetic_refund_items;
CREATE TABLE synthetic_refund_items AS
SELECT
    order_item_id,
    product_id,
    price_usd
FROM vw_refund_candidates
ORDER BY RANDOM()
LIMIT (
    SELECT ROUND(COUNT(*) * 0.05)
    FROM vw_refund_candidates
);

-- ------------------------------------------------------
-- STEP 3: Generate refund records
-- Refund magnitude: 30%–100% of item price
-- ------------------------------------------------------
DROP TABLE IF EXISTS order_item_refund_records;
CREATE TABLE order_item_refund_records AS
SELECT
    ROW_NUMBER() OVER () AS refund_id,
    order_item_id,
    ROUND((price_usd * (0.3 + RANDOM() * 0.7))::numeric, 2) AS refund_amount_usd,
    CURRENT_DATE AS refund_date
FROM synthetic_refund_items;

-- ------------------------------------------------------
-- STEP 4: Granular audit check (sampling)
-- Purpose: Human validation
-- ------------------------------------------------------
SELECT
    r.order_item_id,
    oi.price_usd AS original_price,
    r.refund_amount_usd,
    ROUND((r.refund_amount_usd / oi.price_usd) * 100, 2) AS refund_pct
FROM order_item_refund_records r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
LIMIT 20;

-- ------------------------------------------------------
-- STEP 5: Financial leakage check
-- Expectation: 0 rows returned
-- ------------------------------------------------------
SELECT
    r.refund_id,
    r.order_item_id,
    r.refund_amount_usd,
    oi.price_usd
FROM order_item_refund_records r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
WHERE r.refund_amount_usd > oi.price_usd;
