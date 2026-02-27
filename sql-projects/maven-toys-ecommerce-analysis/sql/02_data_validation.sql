/* 
   2026 DATA INTEGRITY AUDIT SCRIPT
   Identifies discrepancies in Order Counts, Revenue, COGS, and Orphaned Items
*/

-- 1. Check for Item Count Mismatches
SELECT 
    'Item Count Mismatch' AS issue_type,
    o.order_id::text AS reference_id,
    o.items_purchased AS expected_value,
    COUNT(oi.order_item_id) AS actual_value,
    (o.items_purchased - COUNT(oi.order_item_id)) AS difference
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.items_purchased
HAVING o.items_purchased <> COUNT(oi.order_item_id)

UNION ALL

-- 2. Check for Revenue Discrepancies
SELECT 
    'Revenue Discrepancy' AS issue_type,
    o.order_id::text AS reference_id,
    o.price_usd AS expected_value,
    SUM(oi.price_usd) AS actual_value,
    (o.price_usd - SUM(oi.price_usd)) AS difference
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.price_usd
HAVING ABS(o.price_usd - SUM(oi.price_usd)) > 0.01

UNION ALL

-- 3. Check for COGS Discrepancies
SELECT 
    'COGS Discrepancy' AS issue_type,
    o.order_id::text AS reference_id,
    o.cogs_usd AS expected_value,
    SUM(oi.cogs_usd) AS actual_value,
    (o.cogs_usd - SUM(oi.cogs_usd)) AS difference
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.cogs_usd
HAVING ABS(o.cogs_usd - SUM(oi.cogs_usd)) > 0.01

UNION ALL

-- 4. Check for Orphaned Order Items (No Parent Order)
SELECT 
    'Orphaned Order Item' AS issue_type,
    oi.order_item_id::text AS reference_id,
    NULL AS expected_value,
    NULL AS actual_value,
    NULL AS difference
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

ORDER BY issue_type, reference_id;
