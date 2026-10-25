-- 06 (Q5): Top 10 sellers by late-delivery rate (sellers with 100+ delivered orders)
WITH s AS (
    SELECT i.seller_id,
           COUNT(DISTINCT o.order_id) AS orders,
           100.0 * COUNT(DISTINCT CASE WHEN CAST(o.delivered_ts AS date) > CAST(o.estimated_ts AS date)
                                       THEN o.order_id END) / COUNT(DISTINCT o.order_id) AS late_pct
    FROM orders_clean o
    JOIN olist_order_items_dataset i ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered' AND o.delivered_ts IS NOT NULL
    GROUP BY i.seller_id
    HAVING COUNT(DISTINCT o.order_id) >= 100
)
SELECT TOP 10
       seller_id, orders,
       CAST(late_pct AS decimal(5,1)) AS late_pct,
       RANK() OVER (ORDER BY late_pct DESC) AS late_rank
FROM s
ORDER BY late_rank;
