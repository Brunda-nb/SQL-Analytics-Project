/* -------------------------------------------------------------------
   📊 Change Over Time Analysis
------------------------------------------------------------------- 
This section analyzes **sales performance over time** to observe 
how revenue, customer engagement, and product demand evolve.  
It aggregates data by **month** to reveal seasonality, growth trends, 
and performance fluctuations across the year.
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   🛠️ Why Change Over Time Analysis?
-------------------------------------------------------------------
   Change Over Time Analysis is essential for understanding business 
   growth patterns and identifying external/internal factors influencing sales.

   Key benefits include:
   ✅ Detecting seasonality and recurring sales cycles (e.g., festive seasons).  
   ✅ Tracking business growth or decline across months.  
   ✅ Identifying peak and low-performing periods to optimize strategy.  
   ✅ Supporting forecasting, budgeting, and inventory planning.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   ⚡ Example Use Cases
-------------------------------------------------------------------
   - Sales Teams → Align targets with historically strong months.  
   - Marketing Teams → Launch campaigns during low-sales months to boost demand.  
   - Executives → Monitor long-term growth or decline in revenue.  
   - Supply Chain Managers → Plan inventory and logistics based on sales peaks.  
   - Analysts → Compare customer engagement trends over time.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   📈 Sales Performance Over Time (Monthly Trends)  
-------------------------------------------------------------------*/
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
