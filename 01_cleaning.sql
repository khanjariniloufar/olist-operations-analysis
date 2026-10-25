-- 01: Build a clean orders table — convert text timestamps to datetime
-- Raw CSV import stored all dates as nvarchar; empty strings become NULL.
SELECT
    order_id,
    customer_id,
    order_status,
    TRY_CONVERT(datetime2(0), NULLIF(order_purchase_timestamp, ''))      AS purchase_ts,
    TRY_CONVERT(datetime2(0), NULLIF(order_approved_at, ''))             AS approved_ts,
    TRY_CONVERT(datetime2(0), NULLIF(order_delivered_carrier_date, ''))  AS shipped_ts,
    TRY_CONVERT(datetime2(0), NULLIF(order_delivered_customer_date, '')) AS delivered_ts,
    TRY_CONVERT(datetime2(0), NULLIF(order_estimated_delivery_date, '')) AS estimated_ts
INTO orders_clean
FROM olist_orders_dataset;

-- Sanity check: row counts and date range after conversion
SELECT COUNT(*)            AS total_orders,
       COUNT(purchase_ts)  AS has_purchase_date,
       COUNT(delivered_ts) AS has_delivery_date,
       MIN(purchase_ts)    AS first_order,
       MAX(purchase_ts)    AS last_order
FROM orders_clean;
