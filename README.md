E-Commerce SQL Analysis

A SQL-based case study analyzing an e-commerce dataset (Olist-style, Brazilian marketplace schema) covering revenue trends, delivery performance, customer behavior, and product demand. Built entirely in MySQL 8.0.

🎯 Objective

To simulate a real-world business analytics workflow: designing a relational schema, loading raw CSV data, cleaning/transforming it, and answering key business questions that a data analyst would be asked by stakeholders (revenue, delivery, customer value, retention, and product performance).

🗃️ Database Schema
Table	Description
customers	Customer identifiers, location
products	Product attributes (weight, dimensions, category)
orders	Order lifecycle: order date, delivery date, delivery status
orders_item	Line-item level pricing, freight, and revenue
sellers	Seller identifiers and location
order_payments	Payment type, installments, and value
product_category	Category name translation (PT → EN)

Data was loaded via LOAD DATA INFILE from cleaned CSVs, with SET/NULLIF transformations handling blank and malformed date fields during import.

🔍 Analyses Performed

Revenue & Sales

Total revenue, monthly/yearly revenue trend, month-over-month growth rate
Revenue by product category, top 10 revenue-generating products
Revenue contribution share by category (window functions)
Average order value

Delivery & Operations

Average delivery days (overall and by state)
Late delivery rate
Order volume by weekday, hour of day
Average shipping cost by category

Customer Analytics

Customer lifetime value (orders × spend)
Repeat customer count
Customer segmentation by spend (Low / Medium / High value)
RFM analysis (Recency, Frequency, Monetary)
Cohort analysis by first-purchase month
Churn risk detection (customers inactive for 6+ months)

Product Analytics

Product demand trend by month/category
Market basket analysis (frequently co-purchased product pairs)
Pareto analysis (revenue concentration by product)
🛠️ Tools
MySQL 8.0
Window functions (LAG, SUM() OVER)
CTEs and subqueries
Aggregate functions with HAVING/CASE for segmentation
📊 Key Insights

Fill this in with your actual numbers once you run the queries — this is the section recruiters read first.

Total revenue generated: $___
Top revenue-generating category: ___
Average delivery time: ___ days | Late delivery rate: ___%
Repeat customer rate: ___%
Highest-value customer segment contributes ___% of total revenue
📂 Files
EcommerceAnalysisProject.sql — full schema, data load, and analysis queries
🚀 How to Run
Create the database in MySQL 8.0+
Update the LOAD DATA INFILE paths to match your local CSV locations
Run the script top to bottom, or section by section for individual analyses
