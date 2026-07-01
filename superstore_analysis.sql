-- DATABASE SETUP
CREATE DATABASE superstore;
USE superstore;
-- Creating the orders table 
CREATE TABLE orders (
  row_id        INT,
  order_id      VARCHAR(20),
  order_date    VARCHAR(20),
  ship_date     VARCHAR(20),
  ship_mode     VARCHAR(30),
  customer_id   VARCHAR(20),
  customer_name VARCHAR(50),
  segment       VARCHAR(20),
  country       VARCHAR(30),
  city          VARCHAR(50),
  state         VARCHAR(50),
  postal_code   VARCHAR(20),
  region        VARCHAR(20),
  product_id    VARCHAR(20),
  category      VARCHAR(30),
  sub_category  VARCHAR(30),
  product_name  VARCHAR(200),
  sales         DECIMAL(10,2)
);
-- Import data from CSV file (9,800 rows)
LOAD DATA INFILE '/var/lib/mysql-files/train.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM superstore.orders LIMIT 5;
-- STEP 2: BUSINESS ANALYSIS QUERIES
-- Q1: Which region generates the highest sales?
-- Finding: West region leads with highest total sales
SELECT region,
       COUNT(*) AS total_orders,
       ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY region
ORDER BY total_sales DESC;
-- Q2: Which product category sells the most?
-- Finding: Technology is the top selling category
SELECT category,
       COUNT(*) AS total_orders,
       ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY category
ORDER BY total_sales DESC;
-- Q3: Which customer segment brings in most revenue?
-- Finding: Consumer segment dominates sales
SELECT segment,
       COUNT(*) AS total_orders,
       ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY segment
ORDER BY total_sales DESC;
-- Q4: What are the top 10 cities by sales?
-- Finding: New York City ranks #1
SELECT city,
       COUNT(*) AS total_orders,
       ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;
-- Q5: Which shipping mode is most popular?
-- Finding: Standard Class is used most by customers
SELECT ship_mode,
       COUNT(*) AS total_orders,
       ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY ship_mode
ORDER BY total_orders DESC;
-- Q6: What is the monthly sales trend?
-- Finding: Identifies peak and slow sales months
SELECT
    SUBSTRING(order_date, 4, 2) AS month,
    SUBSTRING(order_date, 7, 4) AS year,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY year, month
ORDER BY year, month;
-- Q7: What are the top 10 best selling products?
SELECT product_name,
       COUNT(*) AS times_ordered,
       ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;
-- Q8: Which states generate the most revenue?
-- Finding: Top 10 states driving majority of sales
SELECT state,
       COUNT(*) AS total_orders,
       ROUND(SUM(sales), 2) AS total_sales
FROM superstore.orders
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;
-- SUMMARY
-- 1. West region contributes 31.4% of total sales
-- 2. Technology is the highest revenue category
-- 3. Consumer segment accounts for majority of orders
-- 4. New York City is the #1 city by sales
-- 5. Standard Class is the most preferred shipping mode
-- Total Revenue Analysed: $2,261,536.97
