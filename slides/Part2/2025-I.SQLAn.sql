-- cuboid (drill-down next cuboid)

SELECT PC.product_family, S.store_city, T.the_month, 
SUM(store_sales) AS sales_sum
 FROM sales_fact AS F, product AS P, product_class as PC, 
 time_by_day AS T, store AS S
 WHERE F.product_id = P.product_id 
   AND P.product_class_id = PC.product_class_id
   AND F.time_id = T.time_id 
   AND F.store_id = S.store_id
 GROUP BY PC.product_family, S.store_city, T.the_month --T.quarter 
 ORDER BY PC.product_family, S.store_city, T.the_month --T.quarter 


-- rollup previous cuboid


SELECT S.store_country, T.quarter, SUM(store_sales) AS sales_sum
 FROM sales_fact AS F, product AS P, product_class as PC, time_by_day AS T, store AS S
 WHERE F.time_id = T.time_id 
   AND F.store_id = S.store_id
 GROUP BY S.store_country, T.quarter 
 ORDER BY  S.store_country, T.quarter
 
-- data cube - extended cube by considering all subset of values

SELECT PC.product_family, S.store_country, T.quarter, SUM(store_sales) AS sales_sum
 FROM sales_fact AS F, product AS P, product_class as PC, time_by_day AS T, store AS S
 WHERE F.product_id = P.product_id 
   AND P.product_class_id = PC.product_class_id
   AND F.time_id = T.time_id 
   AND F.store_id = S.store_id
 GROUP BY CUBE(PC.product_family, S.store_country, T.quarter) 
 ORDER BY PC.product_family, S.store_country, T.quarter 
 
-- data cube with ROLLUP - subsequences

SELECT PC.product_family, S.store_country, T.quarter, SUM(store_sales) AS sales_sum
 FROM sales_fact AS F, product AS P, product_class as PC, time_by_day AS T, store AS S
 WHERE F.product_id = P.product_id 
   AND P.product_class_id = PC.product_class_id
   AND F.time_id = T.time_id 
   AND F.store_id = S.store_id
 GROUP BY ROLLUP(PC.product_family, S.store_country, T.quarter) 
 ORDER BY PC.product_family, S.store_country, T.quarter 
 
-- data cube with slice

SELECT PC.product_family, S.store_country, T.quarter, SUM(store_sales) AS sales_sum
 FROM sales_fact AS F, product AS P, product_class as PC, time_by_day AS T, store AS S
 WHERE F.product_id = P.product_id 
   AND P.product_class_id = PC.product_class_id
   AND F.time_id = T.time_id 
   AND F.store_id = S.store_id
   AND T.the_day = 'Monday'
 GROUP BY PC.product_family, S.store_country, T.quarter
 ORDER BY PC.product_family, S.store_country, T.quarter



-- analytic SQL
-- show product_family, store_country, time quarter, 
--number of Products, rank wrt store_country
 

WITH SubQuery AS
(
SELECT PC.product_family, S.store_country, T.quarter, count(*) AS countp
 FROM sales_fact AS F, product AS P, product_class as PC, time_by_day AS T, store AS S
 WHERE F.product_id = P.product_id 
   AND P.product_class_id = PC.product_class_id
   AND F.time_id = T.time_id 
   AND F.store_id = S.store_id
 GROUP BY PC.product_family, S.store_country, T.quarter 
 )
SELECT *, 
		dense_rank() OVER(PARTITION BY store_country ORDER BY countp DESC) As DenseRank,
		rank() OVER(PARTITION BY store_country ORDER BY countp DESC) As Rank
FROM SubQuery
ORDER BY store_country, countp DESC
--ORDER BY product_family, sales_sum DESC
--ORDER BY product_family, store_country, quarter

--Alternative solution

SELECT PC.product_family, S.store_country, T.quarter, SUM(store_sales) AS sales_sum,
dense_rank() OVER(PARTITION BY S.store_country ORDER BY SUM(store_sales) DESC) As DenseRank
 FROM sales_fact AS F, product AS P, product_class as PC, time_by_day AS T, store AS S
 WHERE F.product_id = P.product_id 
   AND P.product_class_id = PC.product_class_id
   AND F.time_id = T.time_id 
   AND F.store_id = S.store_id
 GROUP BY PC.product_family, S.store_country, T.quarter 
ORDER BY store_country, sales_sum DESC
  
-- show product_family, store_country, time quarter, the rank wrt the product family,
-- number of elements in a group defined by the product_family, and the percentage,
--ordered by sales in the group and with percentage 
--of sales over the total of the group

WITH SubQuery AS
(
SELECT PC.product_family, S.store_country, T.quarter, 
 dense_rank() over (partition by PC.product_family order by SUM(store_sales)) as [rank], 
 count(*) over (partition by PC.product_family) as n, 
 SUM(store_sales) AS sales_sum
 FROM sales_fact AS F, product AS P, product_class as PC, time_by_day AS T, store AS S
 WHERE F.product_id = P.product_id 
   AND P.product_class_id = PC.product_class_id
   AND F.time_id = T.time_id 
   AND F.store_id = S.store_id
 GROUP BY PC.product_family, S.store_country, T.quarter
 
 )
SELECT *, sales_sum/sum(sales_sum) OVER(PARTITION BY product_family) AS PercFamily
FROM SubQuery
