# 🛍️ Retail Sales Data Analysis (SQL Project)

## 📌 Overview
This project explores a retail sales dataset using SQL to uncover customer behavior, sales trends, and category performance. It demonstrates advanced SQL techniques including filtering, aggregation, window functions, and self-joins.

---

## 🎯 Objectives
- Analyze sales performance across categories, time, and customer segments.
- Identify top customers, peak sales periods, and repeat purchase behavior.
- Apply self-join logic to model recursive relationships (1:M) within a single table.
- Visualize entity relationships using a clean ER diagram.
- Present actionable insights for business decision-making.

---

## 🗃️ Dataset Description
- **Table Name:** `retail_sales`
- **Key Columns:**
  - `transactions_id` (Primary Key)
  - `customer_id` (Foreign Key)
  - `sale_date`, `sale_time`
  - `category`, `gender`, `age`, `quantity`, `total_sale`

---

## 🧠 Key Insights
- **Best-selling categories:** Electronics leads, followed by Clothing.
- **Customer behavior:** Evening is the most active shopping time.
- **Repeat buyers:** Several customers purchased the same item on different days.
- **Top customers:** Customer ID 3 spent the most — ₹38,440.
- **Monthly trends:** July 2022 and February 2023 were peak months.

---

## 🔍 SQL Case Studies
Each query answers a specific business question:
1. Filter sales by date and category
2. Aggregate total sales by category
3. Average age of Beauty buyers
4. High-value transactions
5. Gender-wise transaction count
6. Monthly average sales with ranking
7. Top 5 customers by total sales
8. Unique customers per category
9. Shift-wise order distribution
10. Self-join to find multi-category buyers
11. Repeat purchases on different dates

---

## 🧩 ER Diagram: Recursive Relationship
Visualizes the 1:M relationship between customers and transactions using a self-join on `customer_id`.

---

## 🚀 How to Run
Use any SQL-compatible environment (MySQL, PostgreSQL, etc.) to execute the queries. Make sure the `retail_sales` table is loaded with appropriate schema and data.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
