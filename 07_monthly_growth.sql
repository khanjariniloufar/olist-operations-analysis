-- 07 (Q6): Monthly orders and revenue with month-over-month order growth
-- Note: Nov–Dec 2016 have <100 orders and are excluded, so the Jan 2017
-- growth value compares against Oct 2016 and should be ignored.
WITH m AS (
    SELECT DATEFROMPARTS(YEAR(o.purchase_ts), MONTH(o.purchase_ts), 1) AS order_month,
           COUNT(DISTINCT o.order_id) AS orders,
           SUM(p.payment_value)       AS revenue
    FROM orders_clean o
    JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY DATEFROMPARTS(YEAR(o.purchase_ts), MONTH(o.purchase_ts), 1)
    HAVING COUNT(DISTINCT o.order_id) >= 100
)
SELECT order_month, orders,
       CAST(revenue AS decimal(12,0)) AS revenue,
       CAST(100.0 * (orders - LAG(orders) OVER (ORDER BY order_month))
            / LAG(orders) OVER (ORDER BY order_month) AS decimal(6,1)) AS orders_growth_pct
FROM m
ORDER BY order_month;
