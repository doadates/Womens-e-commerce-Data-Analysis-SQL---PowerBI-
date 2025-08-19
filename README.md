# Womens Clothing E-commerce Data Analysis (SQL + Power BI)

**Goal:**  
Analyze the *Women’s Clothing E-Commerce Reviews* dataset using SQL for data modeling/aggregation and Power BI for interactive dashboards.  

---

## 🔗 Dataset
- **Source:** [Women’s E-Commerce Clothing Reviews – Kaggle](https://www.kaggle.com/nicapotato/womens-ecommerce-clothing-reviews)  
---

## 🧰 Tech Stack
- **MySQL 8+** → data cleaning, views, aggregations  
- **Power BI Desktop** → dashboard design & visualization  
- **SQL Views** for reusable analysis  

---

## 📁 Repository Structure
/sql -> all SQL scripts (views, cleaning, indexes)

/powerbi -> Power BI file (.pbix) & screenshots

---

## ⚙️ Setup & Usage

### 1) MySQL
1. Create a database, e.g. `ecommerce`.
2. Import the dataset CSV into a table named `womens_ecommerce`.
3. Run the SQL scripts in `/sql`:


2) Power BI

Connect to your MySQL database:

Server: localhost

Database: ecommerce

Use your DB credentials

Load the following views:
- age_distribution_view
- product_engagement_view_quad
- department_review_view
- recommended_item_view
- top_feedback_dep_cust_view

Recreate visuals (bar, pie, donut, scatter with zoom sliders, constant lines for averages).
