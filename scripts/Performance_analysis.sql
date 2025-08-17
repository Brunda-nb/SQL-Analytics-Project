/* -------------------------------------------------------------------
   📊 Performance Analysis
------------------------------------------------------------------- 
This section analyzes the **yearly performance of products** by comparing 
their sales against both their **historical average performance** and their 
**previous year’s sales**.  

It highlights whether products are consistently improving, declining, or 
performing above/below expectations.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   🛠️ Why Performance Analysis?
-------------------------------------------------------------------
   Performance analysis helps in understanding **how individual products 
   are performing year-over-year** and relative to their average trend.  

   Key benefits include:
   ✅ Identifying products with consistent growth vs. decline.  
   ✅ Spotting products performing above or below their long-term average.  
   ✅ Evaluating year-over-year sales changes to detect momentum shifts.  
   ✅ Supporting strategic decisions on promotions, pricing, or phase-outs.  
   ✅ Enabling category-level insights into winners and laggards.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   ⚡ Example Use Cases
-------------------------------------------------------------------
   - Product Managers → Compare yearly sales of each product vs. average.  
   - Sales Teams → Target underperforming products for improvement.  
   - Marketing Teams → Identify products needing campaigns to regain momentum.  
   - Finance Teams → Forecast product-level sales based on performance patterns.  
   - Executives → Detect strong performers driving yearly growth.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   🔎 Step 1: Aggregate yearly product sales
------------------------------------------------------------------- */
/* - Extract year from order date  
   - Join with product dimension  
   - Calculate total yearly sales per product */
with yearly_product_sales as (
    select
        cast(strftime('%Y', f.order_date) as integer) order_year,
        p.product_name,
        sum(f.sales_amount) current_sales
    from gold_fact_sales f
    left join gold_dim_product p
         on f.product_key = p.product_key
    where f.order_date is not null
    group by cast(strftime('%Y', f.order_date) as integer),
             p.product_name
)

/* -------------------------------------------------------------------
   🔎 Step 2: Compare performance
------------------------------------------------------------------- */
/* - Compare each product’s yearly sales to:  
     1. Average sales across years (Above / Below Avg).  
     2. Previous year’s sales (Increase / Decrease / No Change). */
select
    order_year,
    product_name,
    current_sales,
    cast(avg(current_sales) over(partition by product_name) as int) avg_sales,
    current_sales - cast(avg(current_sales) over(partition by product_name) as int) diff_sales,
    case 
        when current_sales - cast(avg(current_sales) over(partition by product_name) as int) > 0 then 'Above Avg'
        when current_sales - cast(avg(current_sales) over(partition by product_name) as int) < 0 then 'Below Avg'
        else 'Avg'
    end avg_change,
    lag(current_sales) over(partition by product_name order by order_year) py_sales,
    current_sales - lag(current_sales) over(partition by product_name order by order_year) py_diff,
    case 
        when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
        when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
        else 'No Change'
    end py_change
from yearly_product_sales
order by product_name, order_year;
