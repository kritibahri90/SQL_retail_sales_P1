-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;
USE sql_project_p1;
-- CREATE TABLE
CREATE TABLE retail_sales 
		    (transactions_id INT PRIMARY KEY,
			sales_date DATE,
			sales_time TIME,
			customer_id INT,
			gender VARCHAR(10),
			age INT,
			category VARCHAR(25),
			quantity INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
);

SELECT * FROM retail_sales;


SELECT 
    COUNT(*)
FROM
    retail_sales;
    
-- Data Cleaning

SELECT * FROM retail_sales
WHERE transactions_id IS NULL  
OR sales_date IS NULL  
OR sales_time IS NULL 
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;  

SELECT * FROM retail_sales
WHERE transactions_id IS NULL  
OR sales_date IS NULL  
OR sales_time IS NULL 
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity =0
OR price_per_unit =0
OR cogs =0
OR total_sale =0; 

SET SQL_SAFE_UPDATES=0;
DELETE FROM retail_sales
WHERE quantity =0
OR price_per_unit =0
OR cogs =0
OR total_sale =0; 


-- Data Exploration

-- How many sales/records we have?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as customer_number FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT category) as unique_category FROM retail_sales;
SELECT DISTINCT category as unique_category FROM retail_sales;

-- Data Analysis & Business Key Problems and Answers

-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    retail_sales
WHERE
    sales_date = '2022-11-05';
    
-- Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022:

SELECT 
 *
FROM
    retail_sales
WHERE category = 'Clothing'
AND YEAR(sales_date)=2022
AND MONTH(sales_date) = 11
AND quantity >=4;


-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category, 
    SUM(total_sale) AS total_sales,
    COUNT(*) as total_orders
FROM
    retail_sales
GROUP BY category;


-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT 
    category, ROUND(AVG(age),2) AS average_age
FROM
    retail_sales
WHERE category = 'Beauty';


-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * 
FROM retail_sales
WHERE total_sale> 1000;

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category, gender,COUNT(transactions_id)
FROM retail_sales
GROUP BY category,gender
ORDER BY category;

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT year, month, average_sale
FROM
(SELECT 
    YEAR(sales_date) AS year,
    MONTH(sales_date) AS month,
    ROUND(AVG(total_sale), 2) AS average_sale,
    RANK() OVER(PARTITION BY  YEAR(sales_date) ORDER BY AVG(total_sale) DESC) as rank_
FROM
    retail_sales
GROUP BY YEAR(sales_date) , MONTH(sales_date)) as t1
WHERE rank_=1;

-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
category,
COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category;

-- Q10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH time_of_theday
AS
(
SELECT *,
CASE
        WHEN sales_time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN sales_time BETWEEN '12:00:01' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales
)
SELECT shift,COUNT(transactions_id) as total_orders
FROM time_of_theday 
GROUP BY shift;	

-- End of Project 


