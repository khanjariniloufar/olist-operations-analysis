-- 08: One flat, clean table exported to CSV for the Power BI dashboard
-- (same is_late definition as the SQL analysis, so numbers match)
SELECT o.order_id, c.customer_state, o.order_status,
       o.purchase_ts, o.approved_ts, o.shipped_ts, o.delivered_ts, o.estimated_ts,
       CASE WHEN o.delivered_ts IS NULL THEN NULL
            WHEN CAST(o.delivered_ts AS date) > CAST(o.estimated_ts AS date) THEN 1
            ELSE 0 END AS is_late,
       DATEDIFF(day, o.purchase_ts, o.delivered_ts) AS delivery_days,
       p.order_value
FROM orders_clean o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
LEFT JOIN (SELECT order_id, SUM(payment_value) AS order_value
           FROM olist_order_payments_dataset GROUP BY order_id) p
       ON o.order_id = p.order_id;
