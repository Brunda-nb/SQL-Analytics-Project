# 📊 KPI Script Overview

This SQL script is designed to generate a **one-stop summary of key performance indicators (KPIs)** from the `gold_fact_sales`, `gold_dim_product`, and `gold_dim_customers` tables.  

It provides both **big-picture metrics** and **business health indicators** in a single query using `UNION ALL`.  

---

## ✅ What it Calculates

- **Total Sales** – overall revenue generated  
- **Total Quantity** – total items sold  
- **Average Price** – average sales amount across all transactions  
- **Total Orders** – number of unique orders  
- **Total Products** – count of distinct products sold  
- **Total Customers** – total unique customers  

---

## 💡 Advanced KPIs

- **Average Order Value (AOV)** → `Total Sales ÷ Total Orders`  
- **Orders per Customer** → `Total Orders ÷ Customers`  
- **Repeat Customer %** → % of customers who placed more than one order  
- **Top Selling Product (by Revenue)** → best performer in terms of sales  
- **Top Country (by Revenue)** → leading geography based on customer sales  

---

## 🎯 Why this Matters  

This script is essentially a **KPI Dashboard in SQL** – instead of running multiple queries, you get all the **core business insights in one result set**.  

- Helps executives track **business health at a glance**  
- Forms the **baseline layer** for dashboards in Tableau / Power BI  
- Ensures consistency by centralizing all KPI definitions in one place  

---  

%%sql
select 'Total Sales' as measure_name, sum(sales_amount) as measure_value from gold_fact_sales 
union all 
select 'Total Quantity' as measure_name, sum(quantity) as measure_value from gold_fact_sales
union all 
select 'Avg Price' as measure_name, round(avg(sales_amount),2) as measure_value from gold_fact_sales
union all 
select 'Total Orders' as measure_name, count(distinct order_number) as measure_value from gold_fact_sales
union all 
select 'Total Products' as measure_name, count(distinct product_id) as measure_value from gold_dim_product
union all 
select 'Total Customers' as measure_name, count(distinct customer_id) as measure_value from gold_dim_customers
union all
-- Average Order Value (AOV = Total Sales ÷ Total Orders)
select 'Avg Order Value', round(sum(sales_amount) * 1.0 / nullif(count(distinct order_number),0), 2)
from gold_fact_sales

union all
-- Orders per Customer (Total Orders ÷ Customers)
select 'Orders per Customer', round(count(distinct order_number) * 1.0 / nullif(count(distinct customer_key),0), 2)
from gold_fact_sales

union all
-- Repeat Customer % (customers with >1 order ÷ total customers)
select 'Repeat Customer %', 
       round((count(distinct case when order_count > 1 then customer_key end) * 100.0) / nullif(count(distinct customer_key),0),2)
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
-- Top Country (by sales) from customer dimension
select 'Top Country (by Sales)', 
       (select country
        from gold_fact_sales fs
        join gold_dim_customers c on fs.customer_key = c.customer_key
        group by c.country
        order by sum(fs.sales_amount) desc
        limit 1);
