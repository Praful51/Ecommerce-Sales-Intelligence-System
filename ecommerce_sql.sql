create database ecommerce;
use ecommerce;

select * from ecommerce;

# 1: total revenue by category

select category,count(*)as total_orders,round(sum(total_revenue),2)as total_revenue,round(avg(total_revenue),2) as avg_revenue
from ecommerce
group by category
order by total_revenue desc;

# 2: purchase rate by marketing channel


select marketing_channel,count(*) as total_orders,sum(purchase_made) as purchases,round(avg(purchase_made)*100,2) as purchase_rate
from ecommerce
group by marketing_channel
order by purchase_rate desc;

#3: monthly revenue trend

with monthly_revenue as(select
month,count(*)as total_orders,sum(total_revenue)as total_revenue
from ecommerce
group by month)

select month, total_orders,total_revenue,lag(total_revenue) over (order by month)as prev_month_revenue,
round(100* (total_revenue-lag(total_revenue)over (order by month))/nullif(lag(total_revenue)over (order by month),0),2)as pct
from monthly_revenue;

# 4: return rate by region

select region,count(*)as total_orders,sum(return_made) as returns,round(avg(return_made)*100,2) as return_rate
from ecommerce
group by region
order by return_rate desc;

# 5: top customer segments by revenue

select customer_segment,count(*) as total_orders, round(sum(total_revenue),2) as total_revenue,ROUND(AVG(total_revenue), 2) AS avg_revenue
from ecommerce
group by customer_segment
order by total_revenue desc;

# 6: Discount Impact

select discount_applied,round (100*avg(purchase_made),2) as purchase_rate
from ecommerce
group by discount_Applied;