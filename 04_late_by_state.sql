-- 04 (Q3): Late-delivery rate and delivery time by customer state
-- States with fewer than 500 delivered orders are excluded.
SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    CAST(100.0 * SUM(CASE WHEN CAST(o.delivered_ts AS date) > CAST(o.estimated_ts AS date)
                          THEN 1 ELSE 0 END) / COUNT(*) AS decimal(5,1)) AS late_pct,
    CAST(AVG(DATEDIFF(day, o.purchase_ts, o.delivered_ts) * 1.0) AS decimal(5,1)) AS avg_delivery_days
FROM orders_clean o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.delivered_ts IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) >= 500
ORDER BY late_pct DESC;
