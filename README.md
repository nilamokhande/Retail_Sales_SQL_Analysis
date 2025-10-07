# Retail Sales Data Analysis (SQL Project)

This project contains a series of SQL queries and insights for analyzing retail sales data. Each case study answers a specific business question using SQL.

---

## My Analysis & Findings

### Q.1: Retrieve all columns for sales made on '2022-11-05'
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```
**Output:**  
There are 11 transactions done in 2022-11-05.

---

### Q.2: Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 or equal to, in the month of Nov-2022 (first 1000 records)
```sql
SELECT * FROM retail_sales
WHERE 
    category = 'Clothing'
    AND quantity >= 4
    AND date_format(sale_date, '%Y-%m')= '2022-11'
LIMIT 0,1000;
```
**Output:**  
In November 2022, there are 18 transactions made with quantity 4 and above in the first 1000 records.

---

### Q.3: Calculate the total sales (total_sale) for each category
```sql
SELECT 
    category, sum(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;
```
**Insights:**  
Electronics category leads the market shares, Clothing is a second-tier market driver, and Beauty may represent an area for potential targeted growth.

---

### Q.4: Find the average age of customers who purchased items from the 'Beauty' category
```sql
SELECT category, avg(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- For rounded average
SELECT ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
```
**Insights:**  
The average age of customers who purchased from the Beauty category is 40.42 years.

---

### Q.5: Find all transactions where the total_sale is greater than 1000
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```
**Output:**  
There are 26 transaction records with a total sale amount exceeding 1,000.

---

### Q.6: Find the total number of transactions (transaction_id) made by each gender in each category
```sql
SELECT category, gender, count(transactions_id) AS total_count
FROM retail_sales
GROUP BY category, gender
ORDER BY category, total_count;
```
**Insights:**  
Males are the primary buyers in Clothing and Electronics. Females strongly lead Beauty products. Males have slightly more transactions (975) than Females (912) across all categories.

---

### Q.7: Calculate the average sale for each month and find the best selling month in each year
```sql
SELECT 
    sale_year, sale_month, avg_sale 
FROM (
    SELECT 
        extract(YEAR FROM sale_date) AS sale_year,
        extract(MONTH FROM sale_date) AS sale_month,
        avg(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY extract(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY sale_year, sale_month
) AS monthly_avg
WHERE rnk = 1;
```
**Insights:**  
In 2022, July is the best month with an average sale of 541.34. In 2023, February is the best month with an average sale of 535.53.

---

### Q.8: Find the top 5 customers based on the highest total sales
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
**Insights:**  
Customer ID 3 is the highest-spending customer, with a total sales amount of ₹38,440.

---

### Q.9: Find the number of unique customers who purchased items from each category
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category;
```
**Insights:**  
- Clothing (149) – Highest unique customers, most popular.  
- Electronics (144) – Very close to clothing, strong demand.  
- Beauty (141) – Slightly lower, but still competitive.

---

### Q.10: Create each shift and number of orders (Morning ≤12, Afternoon 12–17, Evening >17)
```sql
SELECT 
    CASE 
        WHEN extract(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN extract(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift
ORDER BY shift;
```
**Insights:**  
Most customers placed orders in the Evening.

---

### Q.11: Find first 10 Customers Who Bought Items from Two Different Categories (Self Join)
```sql
SELECT DISTINCT t1.customer_id 
FROM retail_sales t1 
JOIN retail_sales t2
ON t1.customer_id = t2.customer_id
AND t1.category <> t2.category 
LIMIT 10;
```
**Insights:**  
These customers purchased products from different categories.

---

### Q.12: Find Customers Who Purchased the Same Item Twice on Different Days (Limit 5)
```sql
SELECT DISTINCT t1.customer_id, t1.category
FROM retail_sales t1 
JOIN retail_sales t2
    ON t1.customer_id = t2.customer_id
    AND t1.category = t2.category
    AND t1.sale_date <> t2.sale_date
LIMIT 5;
```
**Insights:**  
These customers bought from different categories on different dates.


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



I am using a single table for a SQL project, the **1 to Many (1:M)** relationship is best represented by a **Recursive Relationship** (a Self-Join), which shows that **One Customer** is linked to **Many Transactions** within the same table structure.

Here is the clean **Model View ER Diagram** 

---

## 💾 Model View: 1:M Recursive Relationship (Self-Join)

This diagram visualizes the primary **One-to-Many** relationship in your `retail_sales` dataset: the link between a unique customer and all their transactions.

### 1. The Entity (The Table)

| Entity | Attributes (Key Columns) | Data Type | Role |
| :--- | :--- | :--- | :--- |
| **`retail_sales`** | **`transactions_id`** | INT | **Primary Key (PK)** |
| | **`customer_id`** | INT | **Foreign Key / Join Key** |
| | `sale_date` | DATE | |
| | `total_sale` | DECIMAL | |

---

### 2. The 1:M Connection

The relationship is named **`Generates_Transaction`** to clearly explain the business logic: One Customer generates many individual transactions.



### Interpretation:

| Diagram Component | SQL Interpretation (Self-Join Logic) | Cardinality |
| :--- | :--- | :--- |
| **The Single Box** | Represents the table being referenced twice: `retail_sales AS t1` and `retail_sales AS t2`. | |
| **The "One" Side (Single Line)** | Logically represents the unique **Customer** instance (identified by `customer_id`). | **One** |
| **The "Many" Side (Crow's Foot)** | Represents the **multiple transaction records** belonging to that single customer. | **Many** |
| **SQL Join Condition** | This model is enforced in your queries by: `ON t1.customer_id = t2.customer_id`. | |

---

