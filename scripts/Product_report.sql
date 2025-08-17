-- ============================================================
-- Product Report
-- ============================================================
-- Purpose:
--   This report consolidates key product metrics and behaviors.
--
-- Highlights:
--   1. Gathers essential fields such as product name, category, subcategory, and cost.
--   2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
--   3. Aggregates product-level metrics:
--        - total orders
--        - total sales
--        - total quantity sold
--        - total customers (unique)
--        - lifespan (in months)
--   4. Calculates valuable KPIs:
--        - recency (months since last sale)
--        - average order revenue (AOR)
--        - average monthly revenue (AMR)
-- ============================================================

CREATE VIEW gold_report_products AS 
WITH prod_query AS (
    SELECT
        -- 1. Gather essential fields
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        
        -- 3. Aggregations for product-level metrics
        COUNT(DISTINCT f.order_number) AS total_orders,
        SUM(f.sales_amount) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        MAX(f.order_date) AS latest_order,
        COUNT(DISTINCT f.customer_key) AS total_customers,
        CAST(ROUND((julianday(MAX(f.order_date)) - 
                    julianday(MIN(f.order_date))) / 30.0, 2) AS INT) AS lifespan_months,
        
        -- Revenue calculation
        CASE 
            WHEN SUM(f.quantity) = 0 OR SUM(f.quantity) IS NULL THEN 0 
            ELSE SUM(f.quantity) * cost 
        END AS revenue
    FROM gold_dim_product p
    LEFT JOIN gold_fact_sales f 
        ON p.product_key = f.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY p.product_name, p.category, p.subcategory
)

SELECT 
    product_name,
    category, 
    subcategory,
    cost,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    lifespan_months,
    CAST(((julianday('now') - julianday(latest_order)) / 30.0) AS INT) AS recency_months,
    revenue,
    
    -- 2. Revenue Segmentation
    CASE 
        WHEN total_sales > 50000 THEN 'HIGH PERFORMER'
        WHEN total_sales >= 10000 THEN 'MID RANGE'
        ELSE 'LOW PERFORMER'
    END AS revenue_segment,     
    
    -- 4a. Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0 
        ELSE revenue / total_orders 
    END AS avg_order_revenue,
    
    -- 4b. Average Monthly Revenue (AMR)
    CASE 
        WHEN lifespan_months = 0 THEN 0 
        ELSE revenue / lifespan_months 
    END AS avg_monthly_revenue
FROM prod_query;
