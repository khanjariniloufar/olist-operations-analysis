-- 03 (Q2): Monthly late-delivery trend
-- Months with fewer than 100 delivered orders are excluded (unstable rates).
SELECT
    DATEFROMPARTS(YEAR(purchase_ts), MONTH(purchase_ts), 1) AS order_month,
    COUNT(*) AS delivered_orders,
    CAST(100.0 * SUM(CASE WHEN CAST(delivered_ts AS date) > CAST(estimated_ts AS date)
                          THEN 1 ELSE 0 END) / COUNT(*) AS decimal(5,1)) AS late_pct,
    CAST(AVG(DATEDIFF(day, purchase_ts, delivered_ts) * 1.0) AS decimal(5,1)) AS avg_delivery_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND delivered_ts IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(purchase_ts), MONTH(purchase_ts), 1)
HAVING COUNT(*) >= 100
ORDER BY order_month;
