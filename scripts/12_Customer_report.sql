/* -------------------------------------------------------------------
   📊 Customer Report
-------------------------------------------------------------------
   🔎 Purpose:
   This report consolidates **key customer metrics and behaviors** 
   to give a holistic view of customer performance and segmentation.  
   It is designed for business users to quickly identify customer 
   categories, transaction history, and value contributions.  

-------------------------------------------------------------------
   🛠️ Highlights:
   1. Retrieves essential customer details:
        - Names, ages, transactions  
   2. Segments customers into:
        - VIP, Regular, New (based on tenure & spend)  
        - Age groups for demographic analysis  
   3. Aggregates customer-level metrics:
        - Total Orders  
        - Total Sales  
        - Total Quantity Purchased  
        - Total Products Bought  
        - Lifespan (in months since first purchase)  
   4. Calculates KPIs for business insight:
        - Recency (months since last order)  
        - Average Order Value (AOV)  
        - Average Monthly Spend  

-------------------------------------------------------------------
   💡 Business Value:
   - Helps identify **loyal & high-value customers** (VIPs).  
   - Provides clarity on **recency & frequency of engagement**.  
   - Supports **segmentation-driven strategies** (marketing, retention, upsell).  
   - Enables **performance tracking** across different age bands & categories.  

-------------------------------------------------------------------
   🛠️ Implementation (View Definition)
------------------------------------------------------------------- */

CREATE VIEW gold_report_customers AS

-- 1) Base Query: Retrieves core columns from fact & dimension tables
WITH base_query AS (
      SELECT
            f.order_number ,
            f.product_key ,
            f.order_date ,
            f.sales_amount ,
            f.quantity ,
            c.customer_key ,
            c.customer_number ,
            c.first_name ||' '|| c.last_name AS customer_name,
            CAST(((julianday('now') - julianday(c.birthdate)) / 365.0 ) AS int) AS age_year
      FROM gold_fact_sales f
      LEFT JOIN gold_dim_customers c
            ON f.customer_key = c.customer_key
      WHERE order_date IS NOT NULL
)

-- 2) Customer Aggregations: Summarizes metrics at customer level
, customer_aggregation AS (
      SELECT
            customer_key ,
            customer_number ,
            customer_name,
            age_year,
            COUNT(DISTINCT order_number) AS total_orders,
            SUM(sales_amount) AS total_sales ,
            SUM(quantity) AS total_quantity ,
            COUNT(DISTINCT product_key) AS total_products ,
            MAX(order_date) AS latest_order ,
            CAST(ROUND((julianday(MAX(order_date)) - julianday(MIN(order_date))) / 30.0 , 2) AS int) AS lifespan_months
      FROM base_query
      GROUP BY customer_key ,
               customer_number ,
               customer_name,
               age_year
)

-- 3) Final Report: Adds segmentation & KPIs
SELECT
      customer_key ,
      customer_number ,
      customer_name,
      age_year,
      CASE
            WHEN age_year < 18 THEN 'Under 18'
            WHEN age_year BETWEEN 18 AND 24 THEN '18-24'
            WHEN age_year BETWEEN 25 AND 34 THEN '25-34'
            WHEN age_year BETWEEN 35 AND 44 THEN '35-44'
            WHEN age_year BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
      END AS age_group ,
      latest_order ,
      CAST(((julianday('now') - julianday(latest_order)) / 30.0) AS INT) AS recency_months,
      total_orders,
      total_sales ,
      total_quantity ,
      total_products ,
      lifespan_months ,
      CASE
            WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'V.I.P'
            WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
            ELSE 'New'
      END AS customer_group,
      -- Avg Order Value (AOV)
      CASE WHEN total_orders = 0 THEN 0
           ELSE total_sales / total_orders
      END AS avg_order_val ,
      -- Avg Monthly Spend
      CASE WHEN lifespan_months = 0 THEN 0
           ELSE total_sales / lifespan_months
      END AS avg_monthly_spend
FROM customer_aggregation ;
