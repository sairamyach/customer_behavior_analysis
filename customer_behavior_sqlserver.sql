SELECT * FROM [customer_behavior].[dbo].[customer];

--1.
SELECT c.gender, SUM( c.purchase_amount) total_revenue
FROM customer_behavior.dbo.customer c
GROUP BY c.gender;

--2.
SELECT c.customer_id, c.discount_applied, c.purchase_amount
FROM customer_behavior.dbo.customer c
WHERE c.discount_applied LIKE 'Yes' AND c.purchase_amount > (SELECT AVG(c.purchase_amount) average_purchase_amt
															FROM customer_behavior.dbo.customer c); --to find average purchase amount

--3.
SELECT TOP 6 c.item_purchased, ROUND(AVG(c.review_rating),2) avg_rating
FROM customer_behavior.dbo.customer c
GROUP BY c.item_purchased
ORDER BY 2 DESC;

--4.
SELECT c.shipping_type, AVG(c.purchase_amount) average
FROM customer_behavior.dbo.customer c
WHERE c.shipping_type IN ('Standard','Express')
GROUP BY c.shipping_type;

--5.
SELECT AVG(c.purchase_amount) average_spend, SUM(c.purchase_amount) total_revenue, c.subscription_status
FROM customer_behavior.dbo.customer c
GROUP BY c.subscription_status;

--6.
SELECT TOP 5 c.item_purchased, ROUND(100 * SUM(CASE WHEN c.discount_applied = 'Yes' THEN 1.0 ELSE 0.0 END)/COUNT(*),2) as discount_rate
FROM customer_behavior.dbo.customer c
GROUP BY c.item_purchased
ORDER BY discount_rate DESC;

--7.
WITH customer_type AS(SELECT c.previous_purchases , CASE WHEN c.previous_purchases =1 THEN 'new'
                                                WHEN c.previous_purchases <= 10 THEN 'returning'
                                                ELSE 'loyal' END as segment
FROM customer_behavior.dbo.customer c)

SELECT COUNT(*) count_, c1.segment
FROM customer_type c1
GROUP BY c1.segment;

--8.
WITH ranked_items AS (SELECT c.item_purchased,c.category,
ROW_NUMBER() OVER (PARTITION BY c.category ORDER BY COUNT(c.item_purchased) DESC ) rank_
FROM customer_behavior.dbo.customer c
GROUP BY c.category,c.item_purchased)

SELECT *
FROM ranked_items
WHERE rank_ <=3;


--9.
SELECT COUNT(c.customer_id) repeat_customers, c.subscription_status
FROM customer_behavior.dbo.customer c
WHERE c.previous_purchases >5
GROUP BY c.subscription_status;

--10.
SELECT c.age_group, SUM(c.purchase_amount) total_revenue
FROM customer_behavior.dbo.customer c
GROUP BY c.age_group
ORDER BY total_revenue DESC;