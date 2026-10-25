-- 02 (Q1): On-time delivery rate and average delivery time
-- Compared by calendar date: the estimated date has no time (00:00),
-- so a same-day afternoon delivery must not count as late.
SELECT
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN CAST(delivered_ts AS date) <= CAST(estimated_ts AS date)
             THEN 1 ELSE 0 END) AS on_time_orders,
    CAST(100.0 * SUM(CASE WHEN CAST(delivered_ts AS date) <= CAST(estimated_ts AS date)
                          THEN 1 ELSE 0 END) / COUNT(*) AS decimal(5,1)) AS on_time_pct,
    CAST(AVG(DATEDIFF(day, purchase_ts, delivered_ts) * 1.0) AS decimal(5,1)) AS avg_delivery_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND delivered_ts IS NOT NULL;
