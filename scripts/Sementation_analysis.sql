/* -------------------------------------------------------------------
   🎯 Segmentation Analysis
-------------------------------------------------------------------
Segmentation Analysis is the process of dividing data into 
meaningful groups (segments) based on shared attributes such 
as cost, sales, geography, or customer profile.

It helps businesses move beyond overall averages and instead 
understand patterns at a granular level. Segmentation brings 
clarity by identifying clusters of products, customers, or 
markets that behave similarly.

-------------------------------------------------------------------
   🛠️ Why Segmentation Analysis?
-------------------------------------------------------------------
   ✅ Provides deeper insights than overall summaries.  
   ✅ Highlights underperforming or overperforming segments.  
   ✅ Supports targeted strategies for marketing, pricing, or 
      inventory management.  
   ✅ Helps track business performance across different bands 
      (e.g., low-cost vs. premium).  
   ✅ Enables better decision-making by comparing segment-level 
      contributions.  

-------------------------------------------------------------------
   ⚡ Example Use Cases
-------------------------------------------------------------------
   - Retail → Categorize products into budget, mid-range, premium 
     to design pricing & discount strategies.  
   - Banking → Segment customers by income or spending habits 
     to tailor financial products.  
   - Healthcare → Group patients by risk categories for proactive care.  
   - E-commerce → Identify which price segments generate the 
     highest sales or profit.  

-------------------------------------------------------------------
   🔎 Example Implementation (Cost Segmentation)
-------------------------------------------------------------------
Below, products are grouped into cost ranges using CASE logic, 
and the number of products in each segment is counted.
------------------------------------------------------------------- */

with product_segment as (
    select
        product_key,
        product_name,
        cost,
        case 
            when cost < 100 then 'Below 100'
            when cost between 100 and 500 then '100 - 500'
            when cost between 500 and 1000 then '500 - 1000'
            else 'Above 1000'
        end as cost_range
    from gold_dim_product
)

select
    cost_range,
    count(product_key) as Total_products
from product_segment
group by cost_range;
