/* ============================================================
 Change Over Time Analysis
============================================================ */

/* ------------------------------------------------------------
   WHAT:
   Change Over Time Analysis tracks how key business metrics
   (such as sales revenue, order volume, and customer count)
   evolve across different time periods (daily, monthly,
   quarterly, yearly). It provides a chronological view of
   performance and highlights patterns or anomalies.

   WHY:
   - Identify trends in sales and customer behavior
   - Detect seasonality (e.g., festive spikes, off-season dips)
   - Measure business growth or decline over time
   - Support decisions in forecasting, marketing, and planning

   HOW:
   - Extract time components (month, quarter, year) from order_date
   - Aggregate metrics: total revenue, total quantity sold,
     and unique customer count for each time bucket
   - Compare across periods (MoM, YoY) to measure growth or decline
   - Use visualizations (line/bar/area charts) to highlight patterns
------------------------------------------------------------ */

-- Sales Performance Over Time
%%sql
select
    strftime('%m',order_date) Month,
    sum(sales_amount) sales,
    count(distinct customer_key) Coustomer_count,
    sum(quantity) Total_quantity
from gold_fact_sales
where order_date is not null
group by strftime('%m',order_date)
order by strftime('%m',order_date);
