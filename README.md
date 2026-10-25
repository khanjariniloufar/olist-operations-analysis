# Delivery Operations Analysis — Olist E-Commerce (SQL Server + Power BI)

Where and why do online orders arrive late? An operations analysis of ~99,000 real orders from Olist, a Brazilian e-commerce marketplace (2016–2018), done with SQL Server and presented in a Power BI dashboard.

![Dashboard](images/dashboard.png)

## Key findings

| # | Question | Finding |
|---|---|---|
| 1 | How reliable is delivery? | **93.2%** of orders arrive on or before the promised date; average delivery takes **12.5 days**. |
| 2 | When does it get worse? | Late rates peak in **Nov 2017**, **Feb 2018** and **Mar 2018**. |
| 3 | Where does it get worse? | **MA** has a 17.4% late rate vs. **4.5% in SP**, nearly 4× higher (21.5 vs. 8.7 delivery days). |
| 4 | Which stage causes the delay? | **The carrier stage.** Late orders spend 27.9 days with the carrier vs. 8.0 for on-time orders. Seller handover is only ~3 days slower (5.5 vs. 2.6). |
| 5 | Are some sellers worse? | The worst seller (389 orders) is late **19.0%** of the time, roughly 3× the overall average (~6.8%). |
| 6 | Did demand spikes play a role? | Orders jumped **+63% in Nov 2017** (Black Friday), the same month lateness spiked, which suggests volume pressure on the carrier network. Feb–Mar 2018 had stable volume, so a different cause is likely there. |

**Operational takeaway:** the worst *rate* is not the biggest *problem*. MA has the highest late rate but only ~125 late orders, while **SP (~1,820)** and **RJ (~1,490)** generate far more late orders in absolute terms. To reduce the number of unhappy customers, RJ is the priority: high volume *and* a 12.1% late rate.

## Approach

1. **Load and clean** (`01`). Imported 7 CSV tables into SQL Server. All timestamps had been imported as text, so I converted them with `TRY_CONVERT` into a clean `orders_clean` table and validated row counts and date ranges.
2. **Analyze** (`02`–`07`). The analysis uses joins across orders, customers, items and payments, CTEs, `CASE` logic, and window functions (`RANK`, `LAG`).
3. **Guard against small samples.** Months with fewer than 100 orders, states with fewer than 500 and sellers with fewer than 100 are excluded, so tiny groups don't produce misleading 50–100% rates.
4. **Export and visualize** (`08`). I exported one flat table to Power BI and built DAX measures for Delivered Orders, Late Orders, On-Time %, Late %, Avg Delivery Days and Revenue. Because the dashboard uses the same late-delivery definition as the SQL, the numbers match.

**Definition of "late":** delivered *calendar date* is after the estimated delivery date. The estimate has no time component, so a delivery later on the promised day counts as on time.

## Repository

```
sql/
  01_cleaning.sql            text → datetime, clean orders table
  02_on_time_rate.sql        Q1 on-time rate, avg delivery time
  03_monthly_late_trend.sql  Q2 late rate by month
  04_late_by_state.sql       Q3 late rate by customer state
  05_delay_by_stage.sql      Q4 approval / seller / carrier stage durations
  06_seller_ranking.sql      Q5 sellers ranked by late rate (RANK)
  07_monthly_growth.sql      Q6 monthly orders, revenue, MoM growth (LAG)
  08_powerbi_export.sql      flat table for Power BI
olist_operations_dashboard.pbix
images/dashboard.png
```

## Limitations

- These are correlations, not causes. For example, the Black Friday link is supported by timing, not proven.
- The reviews table was not used (malformed multi-line text in the CSV), so customer satisfaction is not analyzed.
- Revenue is the sum of payment values in BRL and includes freight.

## Data

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle, CC BY-NC-SA 4.0). The raw data is not included in this repository. Download it from Kaggle and import the CSVs into a SQL Server database named `olist` to run the scripts.

**Tools:** SQL Server (Docker) · DBeaver · Power BI Desktop · DAX
