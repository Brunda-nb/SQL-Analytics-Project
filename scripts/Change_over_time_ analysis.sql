/* ============================================================
   Change Over Time Analysis
   PURPOSE: Analyze how sales, customers, and quantities evolve
            over time to identify trends and seasonality.
============================================================ */

/* ------------------------------------------------------------
   Why this analysis?
   - Understand sales performance across months
   - Identify peak and low-performing periods
   - Detect seasonality in customer demand
   - Support forecasting & strategic decisions
------------------------------------------------------------ */

/* ------------------------------------------------------------
   Sales Performance Over Time (Monthly Aggregation)
   Output:
     - Month (01 = Jan, 02 = Feb, etc.)
     - Total Sales
     - Unique Customers
     - Total Quantity Sold
------------------------------------------------------------ */

select
    strftime('%Y-%m', order_date) as month,          -- Year-Month for clarity
    sum(sales_amount) as total_sales,                -- Total revenue per month
    count(distinct customer_key) as customer_count,  -- Unique customers per month
    sum(quantity) as total_quantity                  -- Units sold per month
from gold_fact_sales
where order_date is not null
group by strftime('%Y-%m', order_date)
order by strftime('%Y-%m', order_date);

/* ------------------------------------------------------------
   (Optional) Growth Rate Analysis
   Adds month-over-month % growth in sales
------------------------------------------------------------ */

with monthly_sales as (
    select
        strftime('%Y-%m', order_date) as month,
        sum(sales_amount) as total_sales
    from gold_fact_sales
    where order_date is not null
    group by strftime('%Y-%m', order_date)
)
select
    month,
    total_sales,
    round(
        (total_sales - lag(total_sales) over (order by month)) * 100.0
        / lag(total_sales) over (order by month), 2
    ) as mom_growth_percent
from monthly_sales;
