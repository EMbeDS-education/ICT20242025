--7)For every product id, the date with the highest sales of the product. 
--If there are two or more days with  the same highest sales, pick up any date.

with ranked_items as 
(
SELECT f.product_id, p.product_name, t.the_date, sum(store_sales) as total,
rank() over (partition by f.product_id order by sum(store_sales) desc) as rk
from sales_fact f, product p, time_by_day t 
where f.product_id = p.product_id and t.time_id = f.time_id
group by f.product_id, p.product_name, t.the_date 
--order by product_id, rk -- order by cannot be used in a view
)
SELECT product_id, product_name, the_date, total
from ranked_items
where rk = 1
order by product_id, the_date


--4) Produce a report with information about
--a. the cost of each product category, store country and year
--b. the cost of each product category
--c. the cost of each country
--d. the cost of each year
--e. the cost of each product category, store country
--f. the cost of each product category, year
--g. the cost of each store country and year
--h. the total cost

-- tables: sales_fact, time_by_day, store, product, product_class

select pc.product_category, s.store_country, t.the_year, sum(store_cost) as cost
FROM sales_fact f join time_by_day t on f.time_id = t.time_id
JOIN store s on s.store_id = f.store_id JOIN product p on p.product_id=f.product_id
JOIN product_class pc on pc.product_class_id=p.product_class_id
group by cube (pc.product_category, s.store_country, t.the_year)
order by pc.product_category, s.store_country, t.the_year