#---SQL Retail Sales Analysis--
CREATE DATABASE Retails_sales_analysis;
USE Retails_sales_analysis;

#Create table
CREATE TABLE Retail_sales (
transactions_id	 INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(15),
age	INT,
category VARCHAR (15),
quantiy	INT,
price_per_unit FLOAT ,
cogs FLOAT,
total_sale FLOAT);

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
LIMIT 10;

select count(*) FROM retail_sales;

#--DATA CLEANING--
#something error in column header
ALTER table retail_sales
RENAME COLUMN  ï»¿transactions_id TO transations_id;

SELECT * FROM retail_sales
where transactions_id IS null;

DESC retail_sales;
SELECT * FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

#---if any null value in table 
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?

select count(*) FROM retail_sales; #1987

-- How many uniuque customers we have ?
SELECT count(distinct customer_id) from retail_sales; #155

SELECT DISTINCT category FROM retail_sales;

/*  Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q.11) Find Customers Who Bought Items from Two Different Categories (Self Join limit 10)
-- Q.12) Find Customers Who Purchased the Same Item Twice on Different Days(Join limit 5) 
*/

select * FROM retail_sales;
# Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales
where sale_date = '2022-11-05';

/* OUTPUT 
There are 11 transaction done in 2022-11-05
*/

#Q.2)Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
	AND quantity >= 4
    AND date_format(sale_date, '%Y-%m')= '2022-11'
Limit 0,1000;
			
/*--Output--
In November 2022 there is 18 transaction made with quantity is 4 and above.
*/

#Q.3)Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
category, sum(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;

/* Output-
Electronics category Leads the market shares, Represent the Clothing category second tier market driver and last is Beauty This category may represent an area for potential targeted growth initiatives.
*/

#Q.4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, avg(age)AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

/* Output-
The average age of customers who purchased from the Beauty category is 40.42 years. */


#Q.5) Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

/* Output-
There are 26 transaction records with a total sale amount exceeding 1,000. */

#Q.6 )Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender,count(transactions_id) AS total_count
FROM retail_sales
GROUP BY category,gender
ORDER BY category ,total_count;

/* output-
Males are the primary buy the product from Clothing and Electronics category and another is Females strongly lead the Beauty products. 
Males have slightly more transactions (975) than Females (912) across all three categories combined.
*/

#Q.7)Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
sale_year,
sale_month,
avg_sale 
FROM	(SELECT 
	extract(YEAR FROM sale_date)AS sale_year,
	extract(MONTH FROM sale_date)AS sale_month,
    avg(total_sale)AS avg_sale,
RANK() OVER (PARTITION BY extract(YEAR FROM sale_date)
ORDER BY AVG(total_sale)DESC)AS rnk
FROM retail_sales
GROUP BY
sale_year,
sale_month)AS monthly_avg
WHERE rnk =1;

/*  output- 
In 2022 , July is best month with an average sale 541.34 
And in 2023 February is best month with an average sale 535.53
*/

#Q.8) Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT * FROM retail_sales;
SELECT Customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

/*Output-
Customer ID 3 is highest-spending customer, with a total sales amount of 38,440.
*/


#Q.9) Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT DISTINCT category, COUNT(DISTINCT customer_id)AS unique_customer
FROM retail_sales
GROUP BY category;

/*Output-
Clothing (149) → Highest unique customers, most popular.
Electronics (144) → Very close to clothing, strong demand.
Beauty (141) → Slightly lower, but still competitive.
*/

#Q.10) Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
CASE 
	WHEN extract(HOUR FROM sale_time) < 12 then 'Morning'
    WHEN extract(HOUR FROM sale_time) BETWEEN 12 AND 17 then 'Afternoon'
    ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
    FROM retail_sales
    GROUP BY shift
    ORDER BY shift;
    
/*  Output-
Most of customers placed orders at evening.
*/


#Q.11) Find Customers Who Bought Items from Two Different Categories limit 10.
SELECT 
    customer_id
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(category) >= 2
limit 10;

# WITH SELF JOIN

SELECT DISTINCT t1.customer_id 
FROM retail_sales t1 JOIN retail_sales t2
ON t1.customer_id = t2.customer_id
AND t1.category <>t2.category 
LIMIT 10;
    
 /*  Output-
 These customers are purchased product from different category. 
*/


#Q.12) Find Customers Who Purchased the Same Item Twice on Different Days

SELECT DISTINCT t1.customer_id, t1.category
FROM retail_sales t1 JOIN retail_sales t2
	ON t1.customer_id = t2.customer_id
	AND t1.category = t2.category
	AND t1.sale_date <> t2.sale_date
    LIMIT 5;
    
/* Output-
These customers bought from different categories on different dates.
*/


/*-----------------------END--------------------*/