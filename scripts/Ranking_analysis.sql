# 📊 Ranking Analysis

This section performs **ranking-based analysis** to identify the **best and worst performers** across products and customers.  
It leverages the `ROW_NUMBER()` window function to assign ranks based on aggregated measures such as **sales revenue** and **order count**.  

---
## 🛠️ Why Ranking Analysis?

Ranking analysis is essential because it provides **actionable insights** by ordering entities (products, customers, etc.) based on performance metrics.  

Key benefits include:  
- ✅ Identifying **top performers** (products/customers) to reinforce successful strategies.  
- ✅ Spotting **underperformers** that require corrective action.  
- ✅ Supporting **customer segmentation** by distinguishing between high-value and low-engagement users.  
- ✅ Assisting in **product lifecycle decisions** (e.g., promote, bundle, or discontinue low sellers).  

---

## ⚡ Example Use Cases

- **Sales Teams** → Focus on top revenue-generating products/customers.  
- **Marketing Teams** → Target low-engagement customers with reactivation offers or campaigns.  
- **Executives** → Get quick insights into **who and what drives the business most**.  
- **Product Managers** → Decide which products need more investment, promotion, or phase-out.  
- **Customer Success Teams** → Build retention programs for high-value customers while addressing churn risks.  

---

## 🔝 Top 5 products generated highest revenue.  
%%sql
select  
        row_number() over (order by sum(sales_amount) desc ) Rank ,
        p.product_name ,
        sum(sales_amount) Total_Revenue 
from gold_fact_sales f
left join gold_dim_product p
     on f.product_key = p.product_key
group by p.product_name     
limit 5;              

## 📉 What are top 5 products with worst sales.
  %%sql
select  
        row_number() over (order by sum(sales_amount)) Rank ,
        p.product_name ,
        sum(sales_amount) Total_Revenue 
from gold_fact_sales f
left join gold_dim_product p
     on f.product_key = p.product_key
group by p.product_name     
limit 5;    

## 👑Top 10 customers with highest revenue generated.
%%sql
select 
        row_number() over(order by sum(sales_amount) desc) Rank ,
        c.customer_key ,
        first_name ||' '|| last_name as Name ,
        sum(f.sales_amount) Total_revenue
from gold_fact_sales f 
left join gold_dim_customers c
      on f.customer_key = c.customer_key
group by c.customer_key
limit 10;               

## 🙍 Top 3 customers with least orders placed.
%%sql
select 
        count(distinct order_number) Total_orders,
        row_number() over(order by count(distinct order_number) ) Rank ,
        c.customer_key ,
        first_name ||' '|| last_name as Name 
from gold_fact_sales f 
left join gold_dim_customers c
      on f.customer_key = c.customer_key
group by c.customer_key
limit 3; 
