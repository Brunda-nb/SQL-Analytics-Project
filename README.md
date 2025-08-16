# 📊 Data Warehouse Analytics  

This repository contains the **business analytics layer** built on top of the [../data-warehouse-project](https://github.com/Brunda-nb/SQL-DataWarehouse-Project.git).  
It focuses on deriving **business insights** using SQL queries, exploratory analysis, and visualization.  

---

## 🔍 Scope of Analytics  

So far, the project covers **Exploratory Data Analysis (EDA)**:  

- 🗄️ **Database Exploration** – inspecting fact & dimension tables, validating joins, and ensuring data quality.  
- 📂 **Dimension Exploration** – analyzing customer, product, and time dimensions for coverage and consistency.  
- 📅 **Date Exploration** – working with order dates, shipping dates, due dates for trends & seasonality.  
- 🔢 **Measures Exploration (Big Numbers)** – KPIs such as total sales, total customers, average price, and total orders.  
- 📊 **Magnitude Analysis** – identifying which products, customers, or regions contribute most to sales.  
- 🏆 **Ranking** – Top-N and Bottom-N analysis (e.g., top products, least-performing categories).  

---

## 📈 Next Steps (Roadmap)  

The roadmap includes moving into **Advanced Analytics**:  

- 📉 **Change-over-time trends** – monthly/quarterly sales growth, customer retention.  
- ➕ **Cumulative analysis** – running totals of sales, customers.  
- 🎯 **Performance analysis** – targets vs actuals, regional performance.  
- 🥧 **Part-to-whole analysis** – share of category/region in total sales.  
- 👥 **Data segmentation** – customer cohorts, product lines.  
- 📊 **Automated reporting & dashboards** – Tableau / Power BI integration.  

---

## 🛠️ Tech Stack  

- **SQLite** – backend database  
- **SQL** – query language for analytics  
- **Python (Colab / Jupyter)** – running SQL queries & visual exploration  
- **Tableau / Power BI (planned)** – dashboarding & reporting  

---

## 📂 Repository Structure  

```bash
data-warehouse-analytics/
│
├── sql_queries/       # SQL scripts for KPIs, EDA, and advanced analytics
├── notebooks/         # Jupyter/Colab notebooks running SQL + visualizations
├── docs/              # Documentation and insights
└── README.md          # Project overview
