--1) For every customer city, number of different product categories 
--bought by customers of that city

select  c.city, count(distinct pc.product_category) as DistinctProdCat
from sales_fact s join product p on s.product_id = p.product_id
	 join customer c on s.customer_id = c.customer_id 
	 JOIN product_class pc on p.product_class_id=pc.product_class_id
group by c.city;

--2) For every customer city, number of different product categories bought 
-- by customers of that city distributed over the months.

select  c.city, t.the_month, count(distinct pc.product_category) as DistinctProdCat
from sales_fact s join product p on s.product_id = p.product_id
	 join customer c on s.customer_id = c.customer_id 
	 join time_by_day t on s.time_id = t.time_id
	 JOIN product_class pc on p.product_class_id=pc.product_class_id
--group by c.city, t.the_year, t.the_month;
group by c.city, t.the_month
order by c.city;

select  c.city, t.the_year,t.the_month, count(distinct pc.product_category) as DistinctProdCat
from sales_fact s join product p on s.product_id = p.product_id
	 join customer c on s.customer_id = c.customer_id 
	 join time_by_day t on s.time_id = t.time_id
	 JOIN product_class pc on p.product_class_id=pc.product_class_id
	 group by c.city, t.the_year, t.the_month
	 order by c.city, t.the_year;
--group by c.city, t.the_month
--order by c.city


--3) For each store country and month, the number of female customers, 
--the number of male customers performing purchasing on weekends.
with females as(
select  st.store_country, t.the_year, t.the_month, count(distinct c.customer_id) as DistinctFemales
from sales_fact s 
	 join customer c on s.customer_id = c.customer_id 
	 join time_by_day t on s.time_id = t.time_id
	 join store st on s.store_id = st.store_id
where (t.the_day='Sunday' or t.the_day='Saturday') and c.gender='F'
group by st.store_country,  t.the_year, t.the_month
),
males as(
select  st.store_country, t.the_year, t.the_month, count(distinct c.customer_id) as DistinctMales
from sales_fact s 
	 join customer c on s.customer_id = c.customer_id 
	 join time_by_day t on s.time_id = t.time_id
	 join store st on s.store_id = st.store_id
where (t.the_day='Sunday' or t.the_day='Saturday') and c.gender='M'
group by st.store_country,  t.the_year, t.the_month
)
select  m.store_country, m.the_year, m.the_month, f.DistinctFemales, m.DistinctMales 
from males as m , females as f
where m.store_country=f.store_country and m.the_year=f.the_year and m.the_month=f.the_month
order by m.store_country, m.the_year, m.the_month
-- 4) Apply a drill-down operation starting from the above query 3 over the time

--SOL: substitute t.the_month with t.the_day

-- 5) Apply a roll-up operation starting from the above query 4 over the 
-- geographical information.

--SOL: since in store_country is the most general spatial granularity for the roll-up 
-- we need to eliminate store_country. 


-- 6) For every product category and customer country, the store with the highest
-- percentage of sales over the total sales of that category and country. Result must be
-- ordered by percentage descending.

with rk as 
(select pc.product_category, c.country, s.store_id, 
         sum(store_sales)/sum(sum(store_sales)) over (partition by pc.product_category, c.country) as ratio,
         rank() over (partition by pc.product_category, c.country order by sum(store_sales) desc) as rk
from sales_fact s join product p on s.product_id = p.product_id
       join product_class pc on p.product_class_id = pc.product_class_id
       join customer c on s.customer_id = c.customer_id 
group by pc.product_category, c.country, s.store_id) 

select product_category, country, store_id, ratio
from rk where rk=1
order by ratio desc

