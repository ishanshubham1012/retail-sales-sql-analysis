-- 1. Identifying the top five most selling products by total quantity (Delivered only)
with cte as
(
select 
        product_name,
        sum(quantity) as total_quantity_sold,
        dense_rank() over(order by sum(quantity) desc) as rnk
 from  sales
 where status = "delivered"
 group by product_name
 )
 select 
        product_name,
        total_quantity_sold
from cte
where rnk <=5;


-- 2. Analyzing product cancellation frequency to identify potential quality issues (Top 5)
with cte as
(
select
       product_name,
	   sum(case when status = "cancelled" then 1 else 0 end) as ttl_can,
       dense_rank() over(order by sum(case when status = "cancelled" then 1 else 0 end) desc) as rn
from sales 
group by product_name
)
select
        product_name,
        ttl_can
from cte 
where rn <6;

-- 3. Determining the peak shopping window based on time brackets

with cte as 
(
select 
      case 
           when hour(time_of_purchase) between 0 and 5 then "night"
           when hour(time_of_purchase) between 6 and 11 then "morning"
           when hour(time_of_purchase) between 12 and 17 then "afternoon"
           else "evening" 
           end as time_bracket,
      count(*) as number_of_purchases,
      rank() over(order by count(*) desc) as rnk
 from sales
 group by 1
 )
 select * from cte where rnk = 1;
 
-- 4. Identifying the top five highest spending customers by total revenue
with cte as
(
select 
       customer_name,
       sum(quantity*price) as ttl_spent,
       dense_rank() over(order by sum(quantity*price) desc) as rnk
from sales
group by customer_name
)
select 
       customer_name,
       ttl_spent
from cte where rnk <6;

-- 5. Calculating the combined return and cancellation rate per product category

select 
       product_category,
        round( (sum((case when status in ("returned","cancelled") then 1 else 0 end)*1.00) / count(status)) * 100 ,2) as not_successful_rate
from sales
group by 1;

-- 6. Identifying the most preferred payment method used by customers
with cte as
(
select 
       payment_mode,
       count(*) as cnt,
	   rank() over(order by count(*) desc) as rn
from sales
group by 1
)
select 
        payment_mode,
        cnt
from cte
where rn = 1;


-- 7. Visualizing the monthly sales trend to track business growth
-- This format ("%Y-%m") allows SQL to correctly sequence months from Jan to Dec across multiple years (2023-2024), 
-- preventing alphabetical sorting errors that occur with month names.
select 
      date_format(purchase_date, "%Y-%m") as months, 
      sum(quantity*price) as ttl_sales
from sales
group by 1
order by 1;


-- 8. Analyzing category affinity based on customer gender


select 
       product_category,
	   sum(case when gender = "F" then 1 else 0 end) as female,
       sum(case when gender = "M" then 1 else 0 end) as male
from sales
group by 1;

