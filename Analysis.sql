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
with cte as (
select distinct(year(order_date))as 'order_year',month(order_date) as 'order_month',ROUND(sum(sale_price),0) as 'sales'
from df_orders
group by year(order_date),month(order_date)
)
select order_month,
		sum(case when order_year = 2022 then sales else 0 end) as '2022',
        sum(case when order_year = 2023 then sales else 0 end) as '2023'
from cte
group by order_month
order by order_month;
        
-- for each category which month had highest sales 
with cte as(
select category,date_format(order_date,'%Y%m') as 'order_year_month', ROUND(sum(sale_price),0) as 'sales'
from df_orders
group by category,order_year_month
-- order by sales,order_year_month
)
select * from(
select *,
	row_number() over (partition by category order by sales desc) as rn
from cte
) a
where rn=1;


-- which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
  select 
    sub_category, 
    round(sum(profit),0) as profit, 
    year(order_date) as order_year
  from df_orders
  group by sub_category, order_year
)
select 
    sub_category,
    FY2022,
    FY2023,
    (FY2022 - FY2023)*100/(FY2022) as growth
from (
    select 
        sub_category,
        sum(case when order_year = 2022 then profit else 0 end) as FY2022,
        sum(case when order_year = 2023 then profit else 0 end) as FY2023
    from cte
    group by sub_category
) a
order by growth desc;

