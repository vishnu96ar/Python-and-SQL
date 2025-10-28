use python_project;

Select *
From df_orders;

-- find top 10 highest reveue generating products 
SELECT 
    sub_category,
    ROUND(SUM(sale_price * quantity),0) AS total_revenue
FROM df_orders
GROUP BY sub_category
ORDER BY total_revenue DESC
LIMIT 10;

-- find top 5 highest selling products in each region
with cte as (
select region, product_id,sum(sale_price) as sales
from df_orders
group by region, product_id)

select * from (
select *, row_number() over (partition by region order by sales desc) as rn
from cte) A
where rn<=5 ;

-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

-- order by year(order_date),month(order_date)

-- for each category which month had highest sales 

-- order by category,format(order_date,'yyyyMM')

-- which sub category had highest growth by profit in 2023 compare to 2022
