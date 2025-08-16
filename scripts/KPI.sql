/* ==========================================================
   📊 KPI Script Overview
   ==========================================================
   This SQL script generates a one-stop summary of 
   Key Performance Indicators (KPIs) from:
   - gold_fact_sales
   - gold_dim_product
   - gold_dim_customers

   It provides both big-picture metrics and advanced 
   business health indicators in a single query using 
   UNION ALL.
   ========================================================== */


/* =====================
   ✅ Basic KPIs
   ===================== */

-- Total Sales: Overall revenue generated
select 'Total Sales' as measure_name, sum(sales_amount) as measure_value 
from gold_fact_sales

union all
-- Total Quantity: Total items sold
select 'Total Quantity', sum(quantity) 
from gold_fact_sales

union all
-- Average Price: Avg sales amount across all transactions
select 'Avg Price', round(avg(sales_amount),2) 
from gold_fact_sales

union all
-- Total Orders: Unique orders placed
select 'Total Orders', count(distinct order_number) 
from gold_fact_sales

union all
-- Total Products: Distinct products sold
select 'Total Products', count(distinct product_id) 
from gold_dim_product

union all
-- Total Customers: Unique customers
select 'Total Customers', count(distinct customer_id) 
from gold_dim_customers


/* =====================
   💡 Advanced KPIs
   ===================== */

union all
-- Average Order Value (AOV = Total Sales ÷ Total Orders)
select 'Avg Order Value', 
       round(sum(sales_amount) * 1.0 / nullif(count(distinct order_number),0), 2)
from gold_fact_sales

union all
-- Orders per Customer (Total Orders ÷ Customers)
select 'Orders per Customer', 
       round(count(distinct order_number) * 1.0 / nullif(count(distinct customer_key),0), 2)
from gold_fact_sales

union all
-- Repeat Customer % (customers with >1 order ÷ total customers)
select 'Repeat Customer %', 
       round((count(distinct case when order_count > 1 then customer_key end) * 100.0) / 
             nullif(count(distinct customer_key),0), 2)
from (
    select customer_key, count(distinct order_number) as order_count
    from gold_fact_sales
    group by customer_key
) sub

union all
-- Top Selling Product (by revenue)
select 'Top Product (by Sales)', 
       (select product_name
        from gold_fact_sales fs
        join gold_dim_product p on fs.product_key = p.product_key
        group by p.product_name
        order by sum(fs.sales_amount) desc
        limit 1)

union all
-- Top Country (by revenue)
select 'Top Country (by Sales)', 
       (select country
        from gold_fact_sales fs
        join gold_dim_customers c on fs.customer_key = c.customer_key
        group by c.country
        order by sum(fs.sales_amount) desc
        limit 1);
