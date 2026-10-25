-- 05 (Q4): Where does the delay happen? Stage durations, late vs on-time orders
-- approval = purchase -> payment approved
-- seller   = approved -> handed to carrier
-- carrier  = handed to carrier -> delivered to customer
WITH d AS (
    SELECT *,
           CASE WHEN CAST(delivered_ts AS date) > CAST(estimated_ts AS date)
                THEN 'late' ELSE 'on_time' END AS delivery_status
    FROM orders_clean
    WHERE order_status = 'delivered'
      AND approved_ts  IS NOT NULL
      AND shipped_ts   IS NOT NULL
      AND delivered_ts IS NOT NULL
)
SELECT
    delivery_status,
    COUNT(*) AS orders,
    CAST(AVG(DATEDIFF(hour, purchase_ts, approved_ts)  * 1.0) / 24 AS decimal(5,1)) AS approval_days,
    CAST(AVG(DATEDIFF(hour, approved_ts, shipped_ts)   * 1.0) / 24 AS decimal(5,1)) AS seller_days,
    CAST(AVG(DATEDIFF(hour, shipped_ts,  delivered_ts) * 1.0) / 24 AS decimal(5,1)) AS carrier_days
FROM d
GROUP BY delivery_status;
