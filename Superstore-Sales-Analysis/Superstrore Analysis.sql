-- Superstore Sales Analysis — SQL Queries
-- Author: Nikhil Nair
-- Tools: MySQL 8.0
-- Dataset: 9,994 orders loaded into superstore.orders table

USE superstore;

-- BASIC QUERIES
-- Total rows in dataset
SELECT COUNT(*) FROM orders;

SELECT * FROM orders LIMIT 10;

-- Q1: PROFITABILITY BY REGION

WITH profitability AS (
    SELECT region,
           ROUND(SUM(sales), 2) AS total_sales,
           ROUND(SUM(profit), 2) AS total_profit,
           ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
    FROM orders
    GROUP BY region
)
SELECT DENSE_RANK() OVER (ORDER BY profit_margin_pct DESC) AS profitability_rank,
       region,
       total_sales,
       total_profit,
       profit_margin_pct
FROM profitability
ORDER BY profit_margin_pct DESC;

-- Q2: DISCOUNT STRATEGY IMPACT ON PROFIT

SELECT
    CASE
        WHEN discount = 0    THEN '1. No Discount'
        WHEN discount <= 0.20 THEN '2. Low (0-20%)'
        WHEN discount <= 0.40 THEN '3. Medium (21-40%)'
        ELSE                      '4. High (40%+)'
    END AS discount_band,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / (SELECT SUM(profit) FROM orders)) * 100, 2) AS profit_contribution_pct
FROM orders
GROUP BY discount_band
ORDER BY discount_band;

-- Profit without medium and high discount orders

SELECT ROUND(SUM(profit), 2) AS profit_without_heavy_discounts
FROM orders
WHERE discount <= 0.20;

-- Q3: SHIPPING MODE PROFITABILITY

WITH shipping_profit AS (
    SELECT ship_mode,
           COUNT(*) AS total_orders,
           ROUND(SUM(profit), 2) AS total_profit,
           ROUND(AVG(profit), 2) AS avg_profit,
           ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
    FROM orders
    GROUP BY ship_mode
)
SELECT ship_mode, total_orders, total_profit, avg_profit, profit_margin_pct
FROM shipping_profit
ORDER BY profit_margin_pct DESC;

-- Q4: CUSTOMER SEGMENT PERFORMANCE

WITH profitability AS (
    SELECT segment,
           ROUND(SUM(sales), 2) AS total_sales,
           ROUND(SUM(profit), 2) AS total_profit,
           ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
    FROM orders
    GROUP BY segment
)
SELECT DENSE_RANK() OVER (ORDER BY profit_margin_pct DESC) AS profitability_rank,
       segment,
       total_sales,
       total_profit,
       profit_margin_pct
FROM profitability
ORDER BY profit_margin_pct DESC;

-- Q5: PROBLEM PRODUCTS — HIGH SALES BUT LOSING MONEY

WITH sub_category_performance AS (
    SELECT sub_category,
           ROUND(SUM(discount), 2) AS avg_discount,
           ROUND(SUM(sales), 2) AS total_sales,
           SUM(quantity) AS total_quantity,
           ROUND(SUM(profit), 2) AS total_profit,
           ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
    FROM orders
    GROUP BY sub_category
)
SELECT sub_category, total_sales, total_quantity, avg_discount, profit_margin_pct, total_profit
FROM sub_category_performance
WHERE total_profit < 0
ORDER BY total_sales DESC;

-- ADDITIONAL ANALYSIS

-- Total Sales by Region
SELECT region,
       ROUND(SUM(sales), 2) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- Average Profit by Category
SELECT category,
       ROUND(AVG(profit), 2) AS avg_profit
FROM orders
GROUP BY category
ORDER BY avg_profit DESC;

-- Top 5 Orders by Sales
SELECT segment, region, category, sales, profit
FROM orders
ORDER BY sales DESC
LIMIT 5;

-- Loss-making orders count
SELECT COUNT(*) AS loss_orders
FROM orders
WHERE profit < 0;

-- Loss-making Furniture orders
SELECT COUNT(*) AS furniture_loss_orders
FROM orders
WHERE profit < 0 AND category = 'Furniture';

-- West region orders
SELECT COUNT(*) AS west_orders
FROM orders
WHERE region = 'West';

-- Orders with discount > 50%
SELECT COUNT(*) AS high_discount_orders
FROM orders
WHERE discount > 0.5;

-- State with most loss orders
SELECT state, COUNT(*) AS loss_orders
FROM orders
WHERE profit < 0
GROUP BY state
ORDER BY loss_orders DESC
LIMIT 1;

-- Top 5 and Bottom 5 states by profit
(SELECT state, ROUND(SUM(profit), 2) AS total_profit
 FROM orders
 GROUP BY state
 ORDER BY total_profit DESC
 LIMIT 5)
UNION
(SELECT state, ROUND(SUM(profit), 2) AS total_profit
 FROM orders
 GROUP BY state
 ORDER BY total_profit ASC
 LIMIT 5)
ORDER BY total_profit DESC;

-- Sub-categories above overall average profit
WITH sub_category_avg AS (
    SELECT sub_category,
           ROUND(AVG(profit), 2) AS avg_profit
    FROM orders
    GROUP BY sub_category
),
overall_avg AS (
    SELECT ROUND(AVG(profit), 2) AS overall_avg_profit
    FROM orders
)
SELECT sc.sub_category, sc.avg_profit, oa.overall_avg_profit
FROM sub_category_avg sc, overall_avg oa
WHERE sc.avg_profit > oa.overall_avg_profit
ORDER BY sc.avg_profit DESC;

-- Top 3 sub-categories by sales within each category using RANK()
WITH sub_category_sales AS (
    SELECT category,
           sub_category,
           ROUND(SUM(sales), 2) AS total_sales
    FROM orders
    GROUP BY category, sub_category
),
ranked AS (
    SELECT category,
           sub_category,
           total_sales,
           RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS sales_rank
    FROM sub_category_sales
)
SELECT category, sub_category, total_sales, sales_rank
FROM ranked
WHERE sales_rank <= 3
ORDER BY category, sales_rank;

-- Regional profit margin vs company average with performance flag
WITH regional_margin AS (
    SELECT region,
           ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
    FROM orders
    GROUP BY region
),
company_margin AS (
    SELECT ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS company_margin_pct
    FROM orders
)
SELECT region,
       profit_margin_pct,
       company_margin_pct,
       CASE
           WHEN profit_margin_pct > company_margin_pct THEN 'Above Company Average'
           ELSE 'Below Company Average'
       END AS performance
FROM regional_margin, company_margin
ORDER BY profit_margin_pct DESC;