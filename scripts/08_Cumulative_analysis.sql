/* -------------------------------------------------------------------
   📊 Cumulative Analysis
------------------------------------------------------------------- 
This section focuses on **cumulative and rolling measures** to 
understand growth patterns and smooth out fluctuations in sales data.  
It calculates **running totals** and **moving averages** to highlight 
long-term trends beyond month-to-month variations.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   🛠️ Why Cumulative Analysis?
-------------------------------------------------------------------
   Cumulative and rolling analysis helps in identifying **progress over time** 
   instead of isolated snapshots.

   Key benefits include:
   ✅ Tracking overall growth with running totals.  
   ✅ Understanding how revenue accumulates month after month.  
   ✅ Smoothing short-term volatility with moving averages.  
   ✅ Providing a clearer picture of long-term business health.  
   ✅ Supporting forecasting by observing rolling patterns.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   ⚡ Example Use Cases
-------------------------------------------------------------------
   - Executives → Monitor how revenue accumulates across the year.  
   - Analysts → Detect long-term momentum by applying moving averages.  
   - Sales Teams → Measure progress toward annual or quarterly goals.  
   - Finance Teams → Compare cumulative revenue vs. targets/budgets.  
   - Product Managers → Observe how average selling prices trend over time.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   💰 Calculate Total Sales per Month
   📈 Running Total Sales Over Time
   📊 Moving Average Price Over Time
------------------------------------------------------------------- */
%%sql
select
    order_date,
    Total_sales,
    sum(Total_sales) over(order by order_date) Running_Total,
    cast(avg(avg_price) over(order by order_date) as int) Moving_Avg_Price
from
(
    select
        strftime('%Y-%m', order_date) order_date,
        sum(sales_amount) Total_sales,
        avg(price) avg_price
    from gold_fact_sales
    where order_date is not null
    group by strftime('%Y-%m', order_date)
);
