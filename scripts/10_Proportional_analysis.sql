/* -------------------------------------------------------------------
   📊 Proportional Analysis
------------------------------------------------------------------- 
This section identifies **which categories contribute the most to overall sales**.  

By calculating each category’s share of total sales, we can determine 
which categories dominate and which underperform.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   🛠️ Why Proportional Analysis?
-------------------------------------------------------------------
   Proportional analysis provides a clear picture of **sales contribution** 
   across categories.  

   Key benefits include:
   ✅ Identifying top revenue-generating categories.  
   ✅ Understanding category importance in overall business strategy.  
   ✅ Supporting resource allocation (inventory, marketing, pricing).  
   ✅ Detecting underperforming categories that may need improvement.  
   ✅ Providing insights for category expansion or rationalization.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   ⚡ Example Use Cases
-------------------------------------------------------------------
   - Category Managers → Measure share of each category in total sales.  
   - Marketing Teams → Focus campaigns on high-contribution categories.  
   - Supply Chain Teams → Prioritize inventory planning for top sellers.  
   - Finance Teams → Track revenue concentration risk by category.  
   - Executives → Identify growth-driving vs. lagging categories.  
------------------------------------------------------------------- */

/* -------------------------------------------------------------------
   🔎 Step 1: Calculate sales per category
------------------------------------------------------------------- */
/* - Join sales fact table with product dimension  
   - Aggregate total sales by category */
with category_sales as (
    select
        p.category,
        sum(f.sales_amount) Total_sales
    from gold_fact_sales f
    left join gold_dim_product p
         on p.product_key = f.product_key
    group by category
)

/* -------------------------------------------------------------------
   🔎 Step 2: Calculate contribution % to overall sales
------------------------------------------------------------------- */
/* - Compute grand total of sales across all categories  
   - Divide each category’s sales by overall total  
   - Format as % for easier interpretation */
select
    category,
    Total_sales,
    sum(Total_sales) over() overall_sales,
    round((cast(Total_sales as float) / sum(Total_sales) over()) * 100 ,2) || '%' as percentage_of_total
from category_sales;
